
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Kubernetes Engine
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Builds and manages container-based applications, powered by the open source Kubernetes technology.
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
  Call_ContainerProjectsZonesClustersCreate_589009 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersCreate_589011(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersCreate_589010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589012 = path.getOrDefault("zone")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "zone", valid_589012
  var valid_589013 = path.getOrDefault("projectId")
  valid_589013 = validateParameter(valid_589013, JString, required = true,
                                 default = nil)
  if valid_589013 != nil:
    section.add "projectId", valid_589013
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
  section = newJObject()
  var valid_589014 = query.getOrDefault("upload_protocol")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "upload_protocol", valid_589014
  var valid_589015 = query.getOrDefault("fields")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "fields", valid_589015
  var valid_589016 = query.getOrDefault("quotaUser")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "quotaUser", valid_589016
  var valid_589017 = query.getOrDefault("alt")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = newJString("json"))
  if valid_589017 != nil:
    section.add "alt", valid_589017
  var valid_589018 = query.getOrDefault("oauth_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "oauth_token", valid_589018
  var valid_589019 = query.getOrDefault("callback")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "callback", valid_589019
  var valid_589020 = query.getOrDefault("access_token")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "access_token", valid_589020
  var valid_589021 = query.getOrDefault("uploadType")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "uploadType", valid_589021
  var valid_589022 = query.getOrDefault("key")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "key", valid_589022
  var valid_589023 = query.getOrDefault("$.xgafv")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = newJString("1"))
  if valid_589023 != nil:
    section.add "$.xgafv", valid_589023
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

proc call*(call_589026: Call_ContainerProjectsZonesClustersCreate_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_ContainerProjectsZonesClustersCreate_589009;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersCreate
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  var body_589030 = newJObject()
  add(query_589029, "upload_protocol", newJString(uploadProtocol))
  add(path_589028, "zone", newJString(zone))
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "callback", newJString(callback))
  add(query_589029, "access_token", newJString(accessToken))
  add(query_589029, "uploadType", newJString(uploadType))
  add(query_589029, "key", newJString(key))
  add(path_589028, "projectId", newJString(projectId))
  add(query_589029, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589030 = body
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  result = call_589027.call(path_589028, query_589029, nil, nil, body_589030)

var containerProjectsZonesClustersCreate* = Call_ContainerProjectsZonesClustersCreate_589009(
    name: "containerProjectsZonesClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersCreate_589010, base: "/",
    url: url_ContainerProjectsZonesClustersCreate_589011, schemes: {Scheme.Https})
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
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
  var valid_588866 = query.getOrDefault("oauth_token")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "oauth_token", valid_588866
  var valid_588867 = query.getOrDefault("callback")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "callback", valid_588867
  var valid_588868 = query.getOrDefault("access_token")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "access_token", valid_588868
  var valid_588869 = query.getOrDefault("uploadType")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "uploadType", valid_588869
  var valid_588870 = query.getOrDefault("parent")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "parent", valid_588870
  var valid_588871 = query.getOrDefault("key")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "key", valid_588871
  var valid_588872 = query.getOrDefault("$.xgafv")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = newJString("1"))
  if valid_588872 != nil:
    section.add "$.xgafv", valid_588872
  var valid_588873 = query.getOrDefault("prettyPrint")
  valid_588873 = validateParameter(valid_588873, JBool, required = false,
                                 default = newJBool(true))
  if valid_588873 != nil:
    section.add "prettyPrint", valid_588873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588896: Call_ContainerProjectsZonesClustersList_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_588896.validator(path, query, header, formData, body)
  let scheme = call_588896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588896.url(scheme.get, call_588896.host, call_588896.base,
                         call_588896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588896, url, valid)

proc call*(call_588967: Call_ContainerProjectsZonesClustersList_588719;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_588968 = newJObject()
  var query_588970 = newJObject()
  add(query_588970, "upload_protocol", newJString(uploadProtocol))
  add(path_588968, "zone", newJString(zone))
  add(query_588970, "fields", newJString(fields))
  add(query_588970, "quotaUser", newJString(quotaUser))
  add(query_588970, "alt", newJString(alt))
  add(query_588970, "oauth_token", newJString(oauthToken))
  add(query_588970, "callback", newJString(callback))
  add(query_588970, "access_token", newJString(accessToken))
  add(query_588970, "uploadType", newJString(uploadType))
  add(query_588970, "parent", newJString(parent))
  add(query_588970, "key", newJString(key))
  add(path_588968, "projectId", newJString(projectId))
  add(query_588970, "$.xgafv", newJString(Xgafv))
  add(query_588970, "prettyPrint", newJBool(prettyPrint))
  result = call_588967.call(path_588968, query_588970, nil, nil, nil)

var containerProjectsZonesClustersList* = Call_ContainerProjectsZonesClustersList_588719(
    name: "containerProjectsZonesClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersList_588720, base: "/",
    url: url_ContainerProjectsZonesClustersList_588721, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersUpdate_589053 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersUpdate_589055(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersUpdate_589054(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the settings of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589056 = path.getOrDefault("zone")
  valid_589056 = validateParameter(valid_589056, JString, required = true,
                                 default = nil)
  if valid_589056 != nil:
    section.add "zone", valid_589056
  var valid_589057 = path.getOrDefault("projectId")
  valid_589057 = validateParameter(valid_589057, JString, required = true,
                                 default = nil)
  if valid_589057 != nil:
    section.add "projectId", valid_589057
  var valid_589058 = path.getOrDefault("clusterId")
  valid_589058 = validateParameter(valid_589058, JString, required = true,
                                 default = nil)
  if valid_589058 != nil:
    section.add "clusterId", valid_589058
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
  section = newJObject()
  var valid_589059 = query.getOrDefault("upload_protocol")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "upload_protocol", valid_589059
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("quotaUser")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "quotaUser", valid_589061
  var valid_589062 = query.getOrDefault("alt")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("json"))
  if valid_589062 != nil:
    section.add "alt", valid_589062
  var valid_589063 = query.getOrDefault("oauth_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "oauth_token", valid_589063
  var valid_589064 = query.getOrDefault("callback")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "callback", valid_589064
  var valid_589065 = query.getOrDefault("access_token")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "access_token", valid_589065
  var valid_589066 = query.getOrDefault("uploadType")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "uploadType", valid_589066
  var valid_589067 = query.getOrDefault("key")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "key", valid_589067
  var valid_589068 = query.getOrDefault("$.xgafv")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("1"))
  if valid_589068 != nil:
    section.add "$.xgafv", valid_589068
  var valid_589069 = query.getOrDefault("prettyPrint")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "prettyPrint", valid_589069
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

proc call*(call_589071: Call_ContainerProjectsZonesClustersUpdate_589053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific cluster.
  ## 
  let valid = call_589071.validator(path, query, header, formData, body)
  let scheme = call_589071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589071.url(scheme.get, call_589071.host, call_589071.base,
                         call_589071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589071, url, valid)

proc call*(call_589072: Call_ContainerProjectsZonesClustersUpdate_589053;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersUpdate
  ## Updates the settings of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_589073 = newJObject()
  var query_589074 = newJObject()
  var body_589075 = newJObject()
  add(query_589074, "upload_protocol", newJString(uploadProtocol))
  add(path_589073, "zone", newJString(zone))
  add(query_589074, "fields", newJString(fields))
  add(query_589074, "quotaUser", newJString(quotaUser))
  add(query_589074, "alt", newJString(alt))
  add(query_589074, "oauth_token", newJString(oauthToken))
  add(query_589074, "callback", newJString(callback))
  add(query_589074, "access_token", newJString(accessToken))
  add(query_589074, "uploadType", newJString(uploadType))
  add(query_589074, "key", newJString(key))
  add(path_589073, "projectId", newJString(projectId))
  add(query_589074, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589075 = body
  add(query_589074, "prettyPrint", newJBool(prettyPrint))
  add(path_589073, "clusterId", newJString(clusterId))
  result = call_589072.call(path_589073, query_589074, nil, nil, body_589075)

var containerProjectsZonesClustersUpdate* = Call_ContainerProjectsZonesClustersUpdate_589053(
    name: "containerProjectsZonesClustersUpdate", meth: HttpMethod.HttpPut,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersUpdate_589054, base: "/",
    url: url_ContainerProjectsZonesClustersUpdate_589055, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersGet_589031 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersGet_589033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersGet_589032(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to retrieve.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589034 = path.getOrDefault("zone")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "zone", valid_589034
  var valid_589035 = path.getOrDefault("projectId")
  valid_589035 = validateParameter(valid_589035, JString, required = true,
                                 default = nil)
  if valid_589035 != nil:
    section.add "projectId", valid_589035
  var valid_589036 = path.getOrDefault("clusterId")
  valid_589036 = validateParameter(valid_589036, JString, required = true,
                                 default = nil)
  if valid_589036 != nil:
    section.add "clusterId", valid_589036
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
  section = newJObject()
  var valid_589037 = query.getOrDefault("upload_protocol")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "upload_protocol", valid_589037
  var valid_589038 = query.getOrDefault("fields")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "fields", valid_589038
  var valid_589039 = query.getOrDefault("quotaUser")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "quotaUser", valid_589039
  var valid_589040 = query.getOrDefault("alt")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = newJString("json"))
  if valid_589040 != nil:
    section.add "alt", valid_589040
  var valid_589041 = query.getOrDefault("oauth_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "oauth_token", valid_589041
  var valid_589042 = query.getOrDefault("callback")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "callback", valid_589042
  var valid_589043 = query.getOrDefault("access_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "access_token", valid_589043
  var valid_589044 = query.getOrDefault("uploadType")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "uploadType", valid_589044
  var valid_589045 = query.getOrDefault("key")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "key", valid_589045
  var valid_589046 = query.getOrDefault("name")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "name", valid_589046
  var valid_589047 = query.getOrDefault("$.xgafv")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("1"))
  if valid_589047 != nil:
    section.add "$.xgafv", valid_589047
  var valid_589048 = query.getOrDefault("prettyPrint")
  valid_589048 = validateParameter(valid_589048, JBool, required = false,
                                 default = newJBool(true))
  if valid_589048 != nil:
    section.add "prettyPrint", valid_589048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589049: Call_ContainerProjectsZonesClustersGet_589031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific cluster.
  ## 
  let valid = call_589049.validator(path, query, header, formData, body)
  let scheme = call_589049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589049.url(scheme.get, call_589049.host, call_589049.base,
                         call_589049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589049, url, valid)

proc call*(call_589050: Call_ContainerProjectsZonesClustersGet_589031;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersGet
  ## Gets the details of a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to retrieve.
  ## This field has been deprecated and replaced by the name field.
  var path_589051 = newJObject()
  var query_589052 = newJObject()
  add(query_589052, "upload_protocol", newJString(uploadProtocol))
  add(path_589051, "zone", newJString(zone))
  add(query_589052, "fields", newJString(fields))
  add(query_589052, "quotaUser", newJString(quotaUser))
  add(query_589052, "alt", newJString(alt))
  add(query_589052, "oauth_token", newJString(oauthToken))
  add(query_589052, "callback", newJString(callback))
  add(query_589052, "access_token", newJString(accessToken))
  add(query_589052, "uploadType", newJString(uploadType))
  add(query_589052, "key", newJString(key))
  add(query_589052, "name", newJString(name))
  add(path_589051, "projectId", newJString(projectId))
  add(query_589052, "$.xgafv", newJString(Xgafv))
  add(query_589052, "prettyPrint", newJBool(prettyPrint))
  add(path_589051, "clusterId", newJString(clusterId))
  result = call_589050.call(path_589051, query_589052, nil, nil, nil)

var containerProjectsZonesClustersGet* = Call_ContainerProjectsZonesClustersGet_589031(
    name: "containerProjectsZonesClustersGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersGet_589032, base: "/",
    url: url_ContainerProjectsZonesClustersGet_589033, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersDelete_589076 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersDelete_589078(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersDelete_589077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster,
  ## such as load balancer resources, are not deleted if they weren't present
  ## when the cluster was initially created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to delete.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589079 = path.getOrDefault("zone")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "zone", valid_589079
  var valid_589080 = path.getOrDefault("projectId")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "projectId", valid_589080
  var valid_589081 = path.getOrDefault("clusterId")
  valid_589081 = validateParameter(valid_589081, JString, required = true,
                                 default = nil)
  if valid_589081 != nil:
    section.add "clusterId", valid_589081
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
  section = newJObject()
  var valid_589082 = query.getOrDefault("upload_protocol")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "upload_protocol", valid_589082
  var valid_589083 = query.getOrDefault("fields")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "fields", valid_589083
  var valid_589084 = query.getOrDefault("quotaUser")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "quotaUser", valid_589084
  var valid_589085 = query.getOrDefault("alt")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("json"))
  if valid_589085 != nil:
    section.add "alt", valid_589085
  var valid_589086 = query.getOrDefault("oauth_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "oauth_token", valid_589086
  var valid_589087 = query.getOrDefault("callback")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "callback", valid_589087
  var valid_589088 = query.getOrDefault("access_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "access_token", valid_589088
  var valid_589089 = query.getOrDefault("uploadType")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "uploadType", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("name")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "name", valid_589091
  var valid_589092 = query.getOrDefault("$.xgafv")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("1"))
  if valid_589092 != nil:
    section.add "$.xgafv", valid_589092
  var valid_589093 = query.getOrDefault("prettyPrint")
  valid_589093 = validateParameter(valid_589093, JBool, required = false,
                                 default = newJBool(true))
  if valid_589093 != nil:
    section.add "prettyPrint", valid_589093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589094: Call_ContainerProjectsZonesClustersDelete_589076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster,
  ## such as load balancer resources, are not deleted if they weren't present
  ## when the cluster was initially created.
  ## 
  let valid = call_589094.validator(path, query, header, formData, body)
  let scheme = call_589094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589094.url(scheme.get, call_589094.host, call_589094.base,
                         call_589094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589094, url, valid)

proc call*(call_589095: Call_ContainerProjectsZonesClustersDelete_589076;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersDelete
  ## Deletes the cluster, including the Kubernetes endpoint and all worker
  ## nodes.
  ## 
  ## Firewalls and routes that were configured during cluster creation
  ## are also deleted.
  ## 
  ## Other Google Compute Engine resources that might be in use by the cluster,
  ## such as load balancer resources, are not deleted if they weren't present
  ## when the cluster was initially created.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to delete.
  ## This field has been deprecated and replaced by the name field.
  var path_589096 = newJObject()
  var query_589097 = newJObject()
  add(query_589097, "upload_protocol", newJString(uploadProtocol))
  add(path_589096, "zone", newJString(zone))
  add(query_589097, "fields", newJString(fields))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(query_589097, "alt", newJString(alt))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(query_589097, "callback", newJString(callback))
  add(query_589097, "access_token", newJString(accessToken))
  add(query_589097, "uploadType", newJString(uploadType))
  add(query_589097, "key", newJString(key))
  add(query_589097, "name", newJString(name))
  add(path_589096, "projectId", newJString(projectId))
  add(query_589097, "$.xgafv", newJString(Xgafv))
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  add(path_589096, "clusterId", newJString(clusterId))
  result = call_589095.call(path_589096, query_589097, nil, nil, nil)

var containerProjectsZonesClustersDelete* = Call_ContainerProjectsZonesClustersDelete_589076(
    name: "containerProjectsZonesClustersDelete", meth: HttpMethod.HttpDelete,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersDelete_589077, base: "/",
    url: url_ContainerProjectsZonesClustersDelete_589078, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersAddons_589098 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersAddons_589100(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersAddons_589099(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589101 = path.getOrDefault("zone")
  valid_589101 = validateParameter(valid_589101, JString, required = true,
                                 default = nil)
  if valid_589101 != nil:
    section.add "zone", valid_589101
  var valid_589102 = path.getOrDefault("projectId")
  valid_589102 = validateParameter(valid_589102, JString, required = true,
                                 default = nil)
  if valid_589102 != nil:
    section.add "projectId", valid_589102
  var valid_589103 = path.getOrDefault("clusterId")
  valid_589103 = validateParameter(valid_589103, JString, required = true,
                                 default = nil)
  if valid_589103 != nil:
    section.add "clusterId", valid_589103
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
  section = newJObject()
  var valid_589104 = query.getOrDefault("upload_protocol")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "upload_protocol", valid_589104
  var valid_589105 = query.getOrDefault("fields")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "fields", valid_589105
  var valid_589106 = query.getOrDefault("quotaUser")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "quotaUser", valid_589106
  var valid_589107 = query.getOrDefault("alt")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("json"))
  if valid_589107 != nil:
    section.add "alt", valid_589107
  var valid_589108 = query.getOrDefault("oauth_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "oauth_token", valid_589108
  var valid_589109 = query.getOrDefault("callback")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "callback", valid_589109
  var valid_589110 = query.getOrDefault("access_token")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "access_token", valid_589110
  var valid_589111 = query.getOrDefault("uploadType")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "uploadType", valid_589111
  var valid_589112 = query.getOrDefault("key")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "key", valid_589112
  var valid_589113 = query.getOrDefault("$.xgafv")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("1"))
  if valid_589113 != nil:
    section.add "$.xgafv", valid_589113
  var valid_589114 = query.getOrDefault("prettyPrint")
  valid_589114 = validateParameter(valid_589114, JBool, required = false,
                                 default = newJBool(true))
  if valid_589114 != nil:
    section.add "prettyPrint", valid_589114
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

proc call*(call_589116: Call_ContainerProjectsZonesClustersAddons_589098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_589116.validator(path, query, header, formData, body)
  let scheme = call_589116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589116.url(scheme.get, call_589116.host, call_589116.base,
                         call_589116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589116, url, valid)

proc call*(call_589117: Call_ContainerProjectsZonesClustersAddons_589098;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersAddons
  ## Sets the addons for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_589118 = newJObject()
  var query_589119 = newJObject()
  var body_589120 = newJObject()
  add(query_589119, "upload_protocol", newJString(uploadProtocol))
  add(path_589118, "zone", newJString(zone))
  add(query_589119, "fields", newJString(fields))
  add(query_589119, "quotaUser", newJString(quotaUser))
  add(query_589119, "alt", newJString(alt))
  add(query_589119, "oauth_token", newJString(oauthToken))
  add(query_589119, "callback", newJString(callback))
  add(query_589119, "access_token", newJString(accessToken))
  add(query_589119, "uploadType", newJString(uploadType))
  add(query_589119, "key", newJString(key))
  add(path_589118, "projectId", newJString(projectId))
  add(query_589119, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589120 = body
  add(query_589119, "prettyPrint", newJBool(prettyPrint))
  add(path_589118, "clusterId", newJString(clusterId))
  result = call_589117.call(path_589118, query_589119, nil, nil, body_589120)

var containerProjectsZonesClustersAddons* = Call_ContainerProjectsZonesClustersAddons_589098(
    name: "containerProjectsZonesClustersAddons", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/addons",
    validator: validate_ContainerProjectsZonesClustersAddons_589099, base: "/",
    url: url_ContainerProjectsZonesClustersAddons_589100, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLegacyAbac_589121 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersLegacyAbac_589123(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersLegacyAbac_589122(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589124 = path.getOrDefault("zone")
  valid_589124 = validateParameter(valid_589124, JString, required = true,
                                 default = nil)
  if valid_589124 != nil:
    section.add "zone", valid_589124
  var valid_589125 = path.getOrDefault("projectId")
  valid_589125 = validateParameter(valid_589125, JString, required = true,
                                 default = nil)
  if valid_589125 != nil:
    section.add "projectId", valid_589125
  var valid_589126 = path.getOrDefault("clusterId")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "clusterId", valid_589126
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
  section = newJObject()
  var valid_589127 = query.getOrDefault("upload_protocol")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "upload_protocol", valid_589127
  var valid_589128 = query.getOrDefault("fields")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "fields", valid_589128
  var valid_589129 = query.getOrDefault("quotaUser")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "quotaUser", valid_589129
  var valid_589130 = query.getOrDefault("alt")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = newJString("json"))
  if valid_589130 != nil:
    section.add "alt", valid_589130
  var valid_589131 = query.getOrDefault("oauth_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "oauth_token", valid_589131
  var valid_589132 = query.getOrDefault("callback")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "callback", valid_589132
  var valid_589133 = query.getOrDefault("access_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "access_token", valid_589133
  var valid_589134 = query.getOrDefault("uploadType")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "uploadType", valid_589134
  var valid_589135 = query.getOrDefault("key")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "key", valid_589135
  var valid_589136 = query.getOrDefault("$.xgafv")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = newJString("1"))
  if valid_589136 != nil:
    section.add "$.xgafv", valid_589136
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589139: Call_ContainerProjectsZonesClustersLegacyAbac_589121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_589139.validator(path, query, header, formData, body)
  let scheme = call_589139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589139.url(scheme.get, call_589139.host, call_589139.base,
                         call_589139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589139, url, valid)

proc call*(call_589140: Call_ContainerProjectsZonesClustersLegacyAbac_589121;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  var path_589141 = newJObject()
  var query_589142 = newJObject()
  var body_589143 = newJObject()
  add(query_589142, "upload_protocol", newJString(uploadProtocol))
  add(path_589141, "zone", newJString(zone))
  add(query_589142, "fields", newJString(fields))
  add(query_589142, "quotaUser", newJString(quotaUser))
  add(query_589142, "alt", newJString(alt))
  add(query_589142, "oauth_token", newJString(oauthToken))
  add(query_589142, "callback", newJString(callback))
  add(query_589142, "access_token", newJString(accessToken))
  add(query_589142, "uploadType", newJString(uploadType))
  add(query_589142, "key", newJString(key))
  add(path_589141, "projectId", newJString(projectId))
  add(query_589142, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589143 = body
  add(query_589142, "prettyPrint", newJBool(prettyPrint))
  add(path_589141, "clusterId", newJString(clusterId))
  result = call_589140.call(path_589141, query_589142, nil, nil, body_589143)

var containerProjectsZonesClustersLegacyAbac* = Call_ContainerProjectsZonesClustersLegacyAbac_589121(
    name: "containerProjectsZonesClustersLegacyAbac", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/legacyAbac",
    validator: validate_ContainerProjectsZonesClustersLegacyAbac_589122,
    base: "/", url: url_ContainerProjectsZonesClustersLegacyAbac_589123,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLocations_589144 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersLocations_589146(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersLocations_589145(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the locations for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589147 = path.getOrDefault("zone")
  valid_589147 = validateParameter(valid_589147, JString, required = true,
                                 default = nil)
  if valid_589147 != nil:
    section.add "zone", valid_589147
  var valid_589148 = path.getOrDefault("projectId")
  valid_589148 = validateParameter(valid_589148, JString, required = true,
                                 default = nil)
  if valid_589148 != nil:
    section.add "projectId", valid_589148
  var valid_589149 = path.getOrDefault("clusterId")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "clusterId", valid_589149
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
  section = newJObject()
  var valid_589150 = query.getOrDefault("upload_protocol")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "upload_protocol", valid_589150
  var valid_589151 = query.getOrDefault("fields")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "fields", valid_589151
  var valid_589152 = query.getOrDefault("quotaUser")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "quotaUser", valid_589152
  var valid_589153 = query.getOrDefault("alt")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("json"))
  if valid_589153 != nil:
    section.add "alt", valid_589153
  var valid_589154 = query.getOrDefault("oauth_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "oauth_token", valid_589154
  var valid_589155 = query.getOrDefault("callback")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "callback", valid_589155
  var valid_589156 = query.getOrDefault("access_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "access_token", valid_589156
  var valid_589157 = query.getOrDefault("uploadType")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "uploadType", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("$.xgafv")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("1"))
  if valid_589159 != nil:
    section.add "$.xgafv", valid_589159
  var valid_589160 = query.getOrDefault("prettyPrint")
  valid_589160 = validateParameter(valid_589160, JBool, required = false,
                                 default = newJBool(true))
  if valid_589160 != nil:
    section.add "prettyPrint", valid_589160
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

proc call*(call_589162: Call_ContainerProjectsZonesClustersLocations_589144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_589162.validator(path, query, header, formData, body)
  let scheme = call_589162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589162.url(scheme.get, call_589162.host, call_589162.base,
                         call_589162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589162, url, valid)

proc call*(call_589163: Call_ContainerProjectsZonesClustersLocations_589144;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersLocations
  ## Sets the locations for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_589164 = newJObject()
  var query_589165 = newJObject()
  var body_589166 = newJObject()
  add(query_589165, "upload_protocol", newJString(uploadProtocol))
  add(path_589164, "zone", newJString(zone))
  add(query_589165, "fields", newJString(fields))
  add(query_589165, "quotaUser", newJString(quotaUser))
  add(query_589165, "alt", newJString(alt))
  add(query_589165, "oauth_token", newJString(oauthToken))
  add(query_589165, "callback", newJString(callback))
  add(query_589165, "access_token", newJString(accessToken))
  add(query_589165, "uploadType", newJString(uploadType))
  add(query_589165, "key", newJString(key))
  add(path_589164, "projectId", newJString(projectId))
  add(query_589165, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589166 = body
  add(query_589165, "prettyPrint", newJBool(prettyPrint))
  add(path_589164, "clusterId", newJString(clusterId))
  result = call_589163.call(path_589164, query_589165, nil, nil, body_589166)

var containerProjectsZonesClustersLocations* = Call_ContainerProjectsZonesClustersLocations_589144(
    name: "containerProjectsZonesClustersLocations", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/locations",
    validator: validate_ContainerProjectsZonesClustersLocations_589145, base: "/",
    url: url_ContainerProjectsZonesClustersLocations_589146,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLogging_589167 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersLogging_589169(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersLogging_589168(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589170 = path.getOrDefault("zone")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "zone", valid_589170
  var valid_589171 = path.getOrDefault("projectId")
  valid_589171 = validateParameter(valid_589171, JString, required = true,
                                 default = nil)
  if valid_589171 != nil:
    section.add "projectId", valid_589171
  var valid_589172 = path.getOrDefault("clusterId")
  valid_589172 = validateParameter(valid_589172, JString, required = true,
                                 default = nil)
  if valid_589172 != nil:
    section.add "clusterId", valid_589172
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
  section = newJObject()
  var valid_589173 = query.getOrDefault("upload_protocol")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "upload_protocol", valid_589173
  var valid_589174 = query.getOrDefault("fields")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "fields", valid_589174
  var valid_589175 = query.getOrDefault("quotaUser")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "quotaUser", valid_589175
  var valid_589176 = query.getOrDefault("alt")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = newJString("json"))
  if valid_589176 != nil:
    section.add "alt", valid_589176
  var valid_589177 = query.getOrDefault("oauth_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "oauth_token", valid_589177
  var valid_589178 = query.getOrDefault("callback")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "callback", valid_589178
  var valid_589179 = query.getOrDefault("access_token")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "access_token", valid_589179
  var valid_589180 = query.getOrDefault("uploadType")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "uploadType", valid_589180
  var valid_589181 = query.getOrDefault("key")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "key", valid_589181
  var valid_589182 = query.getOrDefault("$.xgafv")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = newJString("1"))
  if valid_589182 != nil:
    section.add "$.xgafv", valid_589182
  var valid_589183 = query.getOrDefault("prettyPrint")
  valid_589183 = validateParameter(valid_589183, JBool, required = false,
                                 default = newJBool(true))
  if valid_589183 != nil:
    section.add "prettyPrint", valid_589183
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

proc call*(call_589185: Call_ContainerProjectsZonesClustersLogging_589167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_589185.validator(path, query, header, formData, body)
  let scheme = call_589185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589185.url(scheme.get, call_589185.host, call_589185.base,
                         call_589185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589185, url, valid)

proc call*(call_589186: Call_ContainerProjectsZonesClustersLogging_589167;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersLogging
  ## Sets the logging service for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_589187 = newJObject()
  var query_589188 = newJObject()
  var body_589189 = newJObject()
  add(query_589188, "upload_protocol", newJString(uploadProtocol))
  add(path_589187, "zone", newJString(zone))
  add(query_589188, "fields", newJString(fields))
  add(query_589188, "quotaUser", newJString(quotaUser))
  add(query_589188, "alt", newJString(alt))
  add(query_589188, "oauth_token", newJString(oauthToken))
  add(query_589188, "callback", newJString(callback))
  add(query_589188, "access_token", newJString(accessToken))
  add(query_589188, "uploadType", newJString(uploadType))
  add(query_589188, "key", newJString(key))
  add(path_589187, "projectId", newJString(projectId))
  add(query_589188, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589189 = body
  add(query_589188, "prettyPrint", newJBool(prettyPrint))
  add(path_589187, "clusterId", newJString(clusterId))
  result = call_589186.call(path_589187, query_589188, nil, nil, body_589189)

var containerProjectsZonesClustersLogging* = Call_ContainerProjectsZonesClustersLogging_589167(
    name: "containerProjectsZonesClustersLogging", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/logging",
    validator: validate_ContainerProjectsZonesClustersLogging_589168, base: "/",
    url: url_ContainerProjectsZonesClustersLogging_589169, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMaster_589190 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersMaster_589192(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersMaster_589191(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the master for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589193 = path.getOrDefault("zone")
  valid_589193 = validateParameter(valid_589193, JString, required = true,
                                 default = nil)
  if valid_589193 != nil:
    section.add "zone", valid_589193
  var valid_589194 = path.getOrDefault("projectId")
  valid_589194 = validateParameter(valid_589194, JString, required = true,
                                 default = nil)
  if valid_589194 != nil:
    section.add "projectId", valid_589194
  var valid_589195 = path.getOrDefault("clusterId")
  valid_589195 = validateParameter(valid_589195, JString, required = true,
                                 default = nil)
  if valid_589195 != nil:
    section.add "clusterId", valid_589195
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
  section = newJObject()
  var valid_589196 = query.getOrDefault("upload_protocol")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "upload_protocol", valid_589196
  var valid_589197 = query.getOrDefault("fields")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "fields", valid_589197
  var valid_589198 = query.getOrDefault("quotaUser")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "quotaUser", valid_589198
  var valid_589199 = query.getOrDefault("alt")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("json"))
  if valid_589199 != nil:
    section.add "alt", valid_589199
  var valid_589200 = query.getOrDefault("oauth_token")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "oauth_token", valid_589200
  var valid_589201 = query.getOrDefault("callback")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "callback", valid_589201
  var valid_589202 = query.getOrDefault("access_token")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "access_token", valid_589202
  var valid_589203 = query.getOrDefault("uploadType")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "uploadType", valid_589203
  var valid_589204 = query.getOrDefault("key")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "key", valid_589204
  var valid_589205 = query.getOrDefault("$.xgafv")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("1"))
  if valid_589205 != nil:
    section.add "$.xgafv", valid_589205
  var valid_589206 = query.getOrDefault("prettyPrint")
  valid_589206 = validateParameter(valid_589206, JBool, required = false,
                                 default = newJBool(true))
  if valid_589206 != nil:
    section.add "prettyPrint", valid_589206
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

proc call*(call_589208: Call_ContainerProjectsZonesClustersMaster_589190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_589208.validator(path, query, header, formData, body)
  let scheme = call_589208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589208.url(scheme.get, call_589208.host, call_589208.base,
                         call_589208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589208, url, valid)

proc call*(call_589209: Call_ContainerProjectsZonesClustersMaster_589190;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersMaster
  ## Updates the master for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_589210 = newJObject()
  var query_589211 = newJObject()
  var body_589212 = newJObject()
  add(query_589211, "upload_protocol", newJString(uploadProtocol))
  add(path_589210, "zone", newJString(zone))
  add(query_589211, "fields", newJString(fields))
  add(query_589211, "quotaUser", newJString(quotaUser))
  add(query_589211, "alt", newJString(alt))
  add(query_589211, "oauth_token", newJString(oauthToken))
  add(query_589211, "callback", newJString(callback))
  add(query_589211, "access_token", newJString(accessToken))
  add(query_589211, "uploadType", newJString(uploadType))
  add(query_589211, "key", newJString(key))
  add(path_589210, "projectId", newJString(projectId))
  add(query_589211, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589212 = body
  add(query_589211, "prettyPrint", newJBool(prettyPrint))
  add(path_589210, "clusterId", newJString(clusterId))
  result = call_589209.call(path_589210, query_589211, nil, nil, body_589212)

var containerProjectsZonesClustersMaster* = Call_ContainerProjectsZonesClustersMaster_589190(
    name: "containerProjectsZonesClustersMaster", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/master",
    validator: validate_ContainerProjectsZonesClustersMaster_589191, base: "/",
    url: url_ContainerProjectsZonesClustersMaster_589192, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMonitoring_589213 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersMonitoring_589215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersMonitoring_589214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the monitoring service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589216 = path.getOrDefault("zone")
  valid_589216 = validateParameter(valid_589216, JString, required = true,
                                 default = nil)
  if valid_589216 != nil:
    section.add "zone", valid_589216
  var valid_589217 = path.getOrDefault("projectId")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "projectId", valid_589217
  var valid_589218 = path.getOrDefault("clusterId")
  valid_589218 = validateParameter(valid_589218, JString, required = true,
                                 default = nil)
  if valid_589218 != nil:
    section.add "clusterId", valid_589218
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
  section = newJObject()
  var valid_589219 = query.getOrDefault("upload_protocol")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "upload_protocol", valid_589219
  var valid_589220 = query.getOrDefault("fields")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "fields", valid_589220
  var valid_589221 = query.getOrDefault("quotaUser")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "quotaUser", valid_589221
  var valid_589222 = query.getOrDefault("alt")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = newJString("json"))
  if valid_589222 != nil:
    section.add "alt", valid_589222
  var valid_589223 = query.getOrDefault("oauth_token")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "oauth_token", valid_589223
  var valid_589224 = query.getOrDefault("callback")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "callback", valid_589224
  var valid_589225 = query.getOrDefault("access_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "access_token", valid_589225
  var valid_589226 = query.getOrDefault("uploadType")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "uploadType", valid_589226
  var valid_589227 = query.getOrDefault("key")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "key", valid_589227
  var valid_589228 = query.getOrDefault("$.xgafv")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("1"))
  if valid_589228 != nil:
    section.add "$.xgafv", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
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

proc call*(call_589231: Call_ContainerProjectsZonesClustersMonitoring_589213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_589231.validator(path, query, header, formData, body)
  let scheme = call_589231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589231.url(scheme.get, call_589231.host, call_589231.base,
                         call_589231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589231, url, valid)

proc call*(call_589232: Call_ContainerProjectsZonesClustersMonitoring_589213;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersMonitoring
  ## Sets the monitoring service for a specific cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_589233 = newJObject()
  var query_589234 = newJObject()
  var body_589235 = newJObject()
  add(query_589234, "upload_protocol", newJString(uploadProtocol))
  add(path_589233, "zone", newJString(zone))
  add(query_589234, "fields", newJString(fields))
  add(query_589234, "quotaUser", newJString(quotaUser))
  add(query_589234, "alt", newJString(alt))
  add(query_589234, "oauth_token", newJString(oauthToken))
  add(query_589234, "callback", newJString(callback))
  add(query_589234, "access_token", newJString(accessToken))
  add(query_589234, "uploadType", newJString(uploadType))
  add(query_589234, "key", newJString(key))
  add(path_589233, "projectId", newJString(projectId))
  add(query_589234, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589235 = body
  add(query_589234, "prettyPrint", newJBool(prettyPrint))
  add(path_589233, "clusterId", newJString(clusterId))
  result = call_589232.call(path_589233, query_589234, nil, nil, body_589235)

var containerProjectsZonesClustersMonitoring* = Call_ContainerProjectsZonesClustersMonitoring_589213(
    name: "containerProjectsZonesClustersMonitoring", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/monitoring",
    validator: validate_ContainerProjectsZonesClustersMonitoring_589214,
    base: "/", url: url_ContainerProjectsZonesClustersMonitoring_589215,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsCreate_589258 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsCreate_589260(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsCreate_589259(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
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
  var valid_589268 = query.getOrDefault("oauth_token")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "oauth_token", valid_589268
  var valid_589269 = query.getOrDefault("callback")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "callback", valid_589269
  var valid_589270 = query.getOrDefault("access_token")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "access_token", valid_589270
  var valid_589271 = query.getOrDefault("uploadType")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "uploadType", valid_589271
  var valid_589272 = query.getOrDefault("key")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "key", valid_589272
  var valid_589273 = query.getOrDefault("$.xgafv")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("1"))
  if valid_589273 != nil:
    section.add "$.xgafv", valid_589273
  var valid_589274 = query.getOrDefault("prettyPrint")
  valid_589274 = validateParameter(valid_589274, JBool, required = false,
                                 default = newJBool(true))
  if valid_589274 != nil:
    section.add "prettyPrint", valid_589274
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

proc call*(call_589276: Call_ContainerProjectsZonesClustersNodePoolsCreate_589258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_589276.validator(path, query, header, formData, body)
  let scheme = call_589276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589276.url(scheme.get, call_589276.host, call_589276.base,
                         call_589276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589276, url, valid)

proc call*(call_589277: Call_ContainerProjectsZonesClustersNodePoolsCreate_589258;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  var path_589278 = newJObject()
  var query_589279 = newJObject()
  var body_589280 = newJObject()
  add(query_589279, "upload_protocol", newJString(uploadProtocol))
  add(path_589278, "zone", newJString(zone))
  add(query_589279, "fields", newJString(fields))
  add(query_589279, "quotaUser", newJString(quotaUser))
  add(query_589279, "alt", newJString(alt))
  add(query_589279, "oauth_token", newJString(oauthToken))
  add(query_589279, "callback", newJString(callback))
  add(query_589279, "access_token", newJString(accessToken))
  add(query_589279, "uploadType", newJString(uploadType))
  add(query_589279, "key", newJString(key))
  add(path_589278, "projectId", newJString(projectId))
  add(query_589279, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589280 = body
  add(query_589279, "prettyPrint", newJBool(prettyPrint))
  add(path_589278, "clusterId", newJString(clusterId))
  result = call_589277.call(path_589278, query_589279, nil, nil, body_589280)

var containerProjectsZonesClustersNodePoolsCreate* = Call_ContainerProjectsZonesClustersNodePoolsCreate_589258(
    name: "containerProjectsZonesClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsCreate_589259,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsCreate_589260,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsList_589236 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsList_589238(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsList_589237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589239 = path.getOrDefault("zone")
  valid_589239 = validateParameter(valid_589239, JString, required = true,
                                 default = nil)
  if valid_589239 != nil:
    section.add "zone", valid_589239
  var valid_589240 = path.getOrDefault("projectId")
  valid_589240 = validateParameter(valid_589240, JString, required = true,
                                 default = nil)
  if valid_589240 != nil:
    section.add "projectId", valid_589240
  var valid_589241 = path.getOrDefault("clusterId")
  valid_589241 = validateParameter(valid_589241, JString, required = true,
                                 default = nil)
  if valid_589241 != nil:
    section.add "clusterId", valid_589241
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589242 = query.getOrDefault("upload_protocol")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "upload_protocol", valid_589242
  var valid_589243 = query.getOrDefault("fields")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "fields", valid_589243
  var valid_589244 = query.getOrDefault("quotaUser")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "quotaUser", valid_589244
  var valid_589245 = query.getOrDefault("alt")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("json"))
  if valid_589245 != nil:
    section.add "alt", valid_589245
  var valid_589246 = query.getOrDefault("oauth_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "oauth_token", valid_589246
  var valid_589247 = query.getOrDefault("callback")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "callback", valid_589247
  var valid_589248 = query.getOrDefault("access_token")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "access_token", valid_589248
  var valid_589249 = query.getOrDefault("uploadType")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "uploadType", valid_589249
  var valid_589250 = query.getOrDefault("parent")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "parent", valid_589250
  var valid_589251 = query.getOrDefault("key")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "key", valid_589251
  var valid_589252 = query.getOrDefault("$.xgafv")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = newJString("1"))
  if valid_589252 != nil:
    section.add "$.xgafv", valid_589252
  var valid_589253 = query.getOrDefault("prettyPrint")
  valid_589253 = validateParameter(valid_589253, JBool, required = false,
                                 default = newJBool(true))
  if valid_589253 != nil:
    section.add "prettyPrint", valid_589253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589254: Call_ContainerProjectsZonesClustersNodePoolsList_589236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_589254.validator(path, query, header, formData, body)
  let scheme = call_589254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589254.url(scheme.get, call_589254.host, call_589254.base,
                         call_589254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589254, url, valid)

proc call*(call_589255: Call_ContainerProjectsZonesClustersNodePoolsList_589236;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; parent: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  var path_589256 = newJObject()
  var query_589257 = newJObject()
  add(query_589257, "upload_protocol", newJString(uploadProtocol))
  add(path_589256, "zone", newJString(zone))
  add(query_589257, "fields", newJString(fields))
  add(query_589257, "quotaUser", newJString(quotaUser))
  add(query_589257, "alt", newJString(alt))
  add(query_589257, "oauth_token", newJString(oauthToken))
  add(query_589257, "callback", newJString(callback))
  add(query_589257, "access_token", newJString(accessToken))
  add(query_589257, "uploadType", newJString(uploadType))
  add(query_589257, "parent", newJString(parent))
  add(query_589257, "key", newJString(key))
  add(path_589256, "projectId", newJString(projectId))
  add(query_589257, "$.xgafv", newJString(Xgafv))
  add(query_589257, "prettyPrint", newJBool(prettyPrint))
  add(path_589256, "clusterId", newJString(clusterId))
  result = call_589255.call(path_589256, query_589257, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsList* = Call_ContainerProjectsZonesClustersNodePoolsList_589236(
    name: "containerProjectsZonesClustersNodePoolsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsList_589237,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsList_589238,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsGet_589281 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsGet_589283(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsGet_589282(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the requested node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589284 = path.getOrDefault("zone")
  valid_589284 = validateParameter(valid_589284, JString, required = true,
                                 default = nil)
  if valid_589284 != nil:
    section.add "zone", valid_589284
  var valid_589285 = path.getOrDefault("nodePoolId")
  valid_589285 = validateParameter(valid_589285, JString, required = true,
                                 default = nil)
  if valid_589285 != nil:
    section.add "nodePoolId", valid_589285
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
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  var valid_589292 = query.getOrDefault("oauth_token")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "oauth_token", valid_589292
  var valid_589293 = query.getOrDefault("callback")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "callback", valid_589293
  var valid_589294 = query.getOrDefault("access_token")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "access_token", valid_589294
  var valid_589295 = query.getOrDefault("uploadType")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "uploadType", valid_589295
  var valid_589296 = query.getOrDefault("key")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "key", valid_589296
  var valid_589297 = query.getOrDefault("name")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "name", valid_589297
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589300: Call_ContainerProjectsZonesClustersNodePoolsGet_589281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_589300.validator(path, query, header, formData, body)
  let scheme = call_589300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589300.url(scheme.get, call_589300.host, call_589300.base,
                         call_589300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589300, url, valid)

proc call*(call_589301: Call_ContainerProjectsZonesClustersNodePoolsGet_589281;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsGet
  ## Retrieves the requested node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_589302 = newJObject()
  var query_589303 = newJObject()
  add(query_589303, "upload_protocol", newJString(uploadProtocol))
  add(path_589302, "zone", newJString(zone))
  add(query_589303, "fields", newJString(fields))
  add(query_589303, "quotaUser", newJString(quotaUser))
  add(query_589303, "alt", newJString(alt))
  add(query_589303, "oauth_token", newJString(oauthToken))
  add(query_589303, "callback", newJString(callback))
  add(query_589303, "access_token", newJString(accessToken))
  add(query_589303, "uploadType", newJString(uploadType))
  add(path_589302, "nodePoolId", newJString(nodePoolId))
  add(query_589303, "key", newJString(key))
  add(query_589303, "name", newJString(name))
  add(path_589302, "projectId", newJString(projectId))
  add(query_589303, "$.xgafv", newJString(Xgafv))
  add(query_589303, "prettyPrint", newJBool(prettyPrint))
  add(path_589302, "clusterId", newJString(clusterId))
  result = call_589301.call(path_589302, query_589303, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsGet* = Call_ContainerProjectsZonesClustersNodePoolsGet_589281(
    name: "containerProjectsZonesClustersNodePoolsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsGet_589282,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsGet_589283,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsDelete_589304 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsDelete_589306(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsDelete_589305(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589307 = path.getOrDefault("zone")
  valid_589307 = validateParameter(valid_589307, JString, required = true,
                                 default = nil)
  if valid_589307 != nil:
    section.add "zone", valid_589307
  var valid_589308 = path.getOrDefault("nodePoolId")
  valid_589308 = validateParameter(valid_589308, JString, required = true,
                                 default = nil)
  if valid_589308 != nil:
    section.add "nodePoolId", valid_589308
  var valid_589309 = path.getOrDefault("projectId")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "projectId", valid_589309
  var valid_589310 = path.getOrDefault("clusterId")
  valid_589310 = validateParameter(valid_589310, JString, required = true,
                                 default = nil)
  if valid_589310 != nil:
    section.add "clusterId", valid_589310
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
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589311 = query.getOrDefault("upload_protocol")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "upload_protocol", valid_589311
  var valid_589312 = query.getOrDefault("fields")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "fields", valid_589312
  var valid_589313 = query.getOrDefault("quotaUser")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "quotaUser", valid_589313
  var valid_589314 = query.getOrDefault("alt")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = newJString("json"))
  if valid_589314 != nil:
    section.add "alt", valid_589314
  var valid_589315 = query.getOrDefault("oauth_token")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "oauth_token", valid_589315
  var valid_589316 = query.getOrDefault("callback")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "callback", valid_589316
  var valid_589317 = query.getOrDefault("access_token")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "access_token", valid_589317
  var valid_589318 = query.getOrDefault("uploadType")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "uploadType", valid_589318
  var valid_589319 = query.getOrDefault("key")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "key", valid_589319
  var valid_589320 = query.getOrDefault("name")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "name", valid_589320
  var valid_589321 = query.getOrDefault("$.xgafv")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("1"))
  if valid_589321 != nil:
    section.add "$.xgafv", valid_589321
  var valid_589322 = query.getOrDefault("prettyPrint")
  valid_589322 = validateParameter(valid_589322, JBool, required = false,
                                 default = newJBool(true))
  if valid_589322 != nil:
    section.add "prettyPrint", valid_589322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589323: Call_ContainerProjectsZonesClustersNodePoolsDelete_589304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_589323.validator(path, query, header, formData, body)
  let scheme = call_589323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589323.url(scheme.get, call_589323.host, call_589323.base,
                         call_589323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589323, url, valid)

proc call*(call_589324: Call_ContainerProjectsZonesClustersNodePoolsDelete_589304;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_589325 = newJObject()
  var query_589326 = newJObject()
  add(query_589326, "upload_protocol", newJString(uploadProtocol))
  add(path_589325, "zone", newJString(zone))
  add(query_589326, "fields", newJString(fields))
  add(query_589326, "quotaUser", newJString(quotaUser))
  add(query_589326, "alt", newJString(alt))
  add(query_589326, "oauth_token", newJString(oauthToken))
  add(query_589326, "callback", newJString(callback))
  add(query_589326, "access_token", newJString(accessToken))
  add(query_589326, "uploadType", newJString(uploadType))
  add(path_589325, "nodePoolId", newJString(nodePoolId))
  add(query_589326, "key", newJString(key))
  add(query_589326, "name", newJString(name))
  add(path_589325, "projectId", newJString(projectId))
  add(query_589326, "$.xgafv", newJString(Xgafv))
  add(query_589326, "prettyPrint", newJBool(prettyPrint))
  add(path_589325, "clusterId", newJString(clusterId))
  result = call_589324.call(path_589325, query_589326, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsDelete* = Call_ContainerProjectsZonesClustersNodePoolsDelete_589304(
    name: "containerProjectsZonesClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsDelete_589305,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsDelete_589306,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_589327 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsAutoscaling_589329(
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_589328(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589330 = path.getOrDefault("zone")
  valid_589330 = validateParameter(valid_589330, JString, required = true,
                                 default = nil)
  if valid_589330 != nil:
    section.add "zone", valid_589330
  var valid_589331 = path.getOrDefault("nodePoolId")
  valid_589331 = validateParameter(valid_589331, JString, required = true,
                                 default = nil)
  if valid_589331 != nil:
    section.add "nodePoolId", valid_589331
  var valid_589332 = path.getOrDefault("projectId")
  valid_589332 = validateParameter(valid_589332, JString, required = true,
                                 default = nil)
  if valid_589332 != nil:
    section.add "projectId", valid_589332
  var valid_589333 = path.getOrDefault("clusterId")
  valid_589333 = validateParameter(valid_589333, JString, required = true,
                                 default = nil)
  if valid_589333 != nil:
    section.add "clusterId", valid_589333
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
  section = newJObject()
  var valid_589334 = query.getOrDefault("upload_protocol")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "upload_protocol", valid_589334
  var valid_589335 = query.getOrDefault("fields")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "fields", valid_589335
  var valid_589336 = query.getOrDefault("quotaUser")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "quotaUser", valid_589336
  var valid_589337 = query.getOrDefault("alt")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = newJString("json"))
  if valid_589337 != nil:
    section.add "alt", valid_589337
  var valid_589338 = query.getOrDefault("oauth_token")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "oauth_token", valid_589338
  var valid_589339 = query.getOrDefault("callback")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "callback", valid_589339
  var valid_589340 = query.getOrDefault("access_token")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "access_token", valid_589340
  var valid_589341 = query.getOrDefault("uploadType")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "uploadType", valid_589341
  var valid_589342 = query.getOrDefault("key")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "key", valid_589342
  var valid_589343 = query.getOrDefault("$.xgafv")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = newJString("1"))
  if valid_589343 != nil:
    section.add "$.xgafv", valid_589343
  var valid_589344 = query.getOrDefault("prettyPrint")
  valid_589344 = validateParameter(valid_589344, JBool, required = false,
                                 default = newJBool(true))
  if valid_589344 != nil:
    section.add "prettyPrint", valid_589344
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

proc call*(call_589346: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_589327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_589346.validator(path, query, header, formData, body)
  let scheme = call_589346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589346.url(scheme.get, call_589346.host, call_589346.base,
                         call_589346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589346, url, valid)

proc call*(call_589347: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_589327;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsAutoscaling
  ## Sets the autoscaling settings for the specified node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_589348 = newJObject()
  var query_589349 = newJObject()
  var body_589350 = newJObject()
  add(query_589349, "upload_protocol", newJString(uploadProtocol))
  add(path_589348, "zone", newJString(zone))
  add(query_589349, "fields", newJString(fields))
  add(query_589349, "quotaUser", newJString(quotaUser))
  add(query_589349, "alt", newJString(alt))
  add(query_589349, "oauth_token", newJString(oauthToken))
  add(query_589349, "callback", newJString(callback))
  add(query_589349, "access_token", newJString(accessToken))
  add(query_589349, "uploadType", newJString(uploadType))
  add(path_589348, "nodePoolId", newJString(nodePoolId))
  add(query_589349, "key", newJString(key))
  add(path_589348, "projectId", newJString(projectId))
  add(query_589349, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589350 = body
  add(query_589349, "prettyPrint", newJBool(prettyPrint))
  add(path_589348, "clusterId", newJString(clusterId))
  result = call_589347.call(path_589348, query_589349, nil, nil, body_589350)

var containerProjectsZonesClustersNodePoolsAutoscaling* = Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_589327(
    name: "containerProjectsZonesClustersNodePoolsAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/autoscaling",
    validator: validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_589328,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsAutoscaling_589329,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetManagement_589351 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsSetManagement_589353(
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsSetManagement_589352(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the NodeManagement options for a node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589354 = path.getOrDefault("zone")
  valid_589354 = validateParameter(valid_589354, JString, required = true,
                                 default = nil)
  if valid_589354 != nil:
    section.add "zone", valid_589354
  var valid_589355 = path.getOrDefault("nodePoolId")
  valid_589355 = validateParameter(valid_589355, JString, required = true,
                                 default = nil)
  if valid_589355 != nil:
    section.add "nodePoolId", valid_589355
  var valid_589356 = path.getOrDefault("projectId")
  valid_589356 = validateParameter(valid_589356, JString, required = true,
                                 default = nil)
  if valid_589356 != nil:
    section.add "projectId", valid_589356
  var valid_589357 = path.getOrDefault("clusterId")
  valid_589357 = validateParameter(valid_589357, JString, required = true,
                                 default = nil)
  if valid_589357 != nil:
    section.add "clusterId", valid_589357
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
  section = newJObject()
  var valid_589358 = query.getOrDefault("upload_protocol")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "upload_protocol", valid_589358
  var valid_589359 = query.getOrDefault("fields")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "fields", valid_589359
  var valid_589360 = query.getOrDefault("quotaUser")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "quotaUser", valid_589360
  var valid_589361 = query.getOrDefault("alt")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = newJString("json"))
  if valid_589361 != nil:
    section.add "alt", valid_589361
  var valid_589362 = query.getOrDefault("oauth_token")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "oauth_token", valid_589362
  var valid_589363 = query.getOrDefault("callback")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "callback", valid_589363
  var valid_589364 = query.getOrDefault("access_token")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "access_token", valid_589364
  var valid_589365 = query.getOrDefault("uploadType")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "uploadType", valid_589365
  var valid_589366 = query.getOrDefault("key")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "key", valid_589366
  var valid_589367 = query.getOrDefault("$.xgafv")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = newJString("1"))
  if valid_589367 != nil:
    section.add "$.xgafv", valid_589367
  var valid_589368 = query.getOrDefault("prettyPrint")
  valid_589368 = validateParameter(valid_589368, JBool, required = false,
                                 default = newJBool(true))
  if valid_589368 != nil:
    section.add "prettyPrint", valid_589368
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

proc call*(call_589370: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_589351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_589370.validator(path, query, header, formData, body)
  let scheme = call_589370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589370.url(scheme.get, call_589370.host, call_589370.base,
                         call_589370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589370, url, valid)

proc call*(call_589371: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_589351;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  var path_589372 = newJObject()
  var query_589373 = newJObject()
  var body_589374 = newJObject()
  add(query_589373, "upload_protocol", newJString(uploadProtocol))
  add(path_589372, "zone", newJString(zone))
  add(query_589373, "fields", newJString(fields))
  add(query_589373, "quotaUser", newJString(quotaUser))
  add(query_589373, "alt", newJString(alt))
  add(query_589373, "oauth_token", newJString(oauthToken))
  add(query_589373, "callback", newJString(callback))
  add(query_589373, "access_token", newJString(accessToken))
  add(query_589373, "uploadType", newJString(uploadType))
  add(path_589372, "nodePoolId", newJString(nodePoolId))
  add(query_589373, "key", newJString(key))
  add(path_589372, "projectId", newJString(projectId))
  add(query_589373, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589374 = body
  add(query_589373, "prettyPrint", newJBool(prettyPrint))
  add(path_589372, "clusterId", newJString(clusterId))
  result = call_589371.call(path_589372, query_589373, nil, nil, body_589374)

var containerProjectsZonesClustersNodePoolsSetManagement* = Call_ContainerProjectsZonesClustersNodePoolsSetManagement_589351(
    name: "containerProjectsZonesClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setManagement",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetManagement_589352,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetManagement_589353,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetSize_589375 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsSetSize_589377(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId"),
               (kind: ConstantSegment, value: "/nodePools/"),
               (kind: VariableSegment, value: "nodePoolId"),
               (kind: ConstantSegment, value: "/setSize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsSetSize_589376(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the size for a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589378 = path.getOrDefault("zone")
  valid_589378 = validateParameter(valid_589378, JString, required = true,
                                 default = nil)
  if valid_589378 != nil:
    section.add "zone", valid_589378
  var valid_589379 = path.getOrDefault("nodePoolId")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "nodePoolId", valid_589379
  var valid_589380 = path.getOrDefault("projectId")
  valid_589380 = validateParameter(valid_589380, JString, required = true,
                                 default = nil)
  if valid_589380 != nil:
    section.add "projectId", valid_589380
  var valid_589381 = path.getOrDefault("clusterId")
  valid_589381 = validateParameter(valid_589381, JString, required = true,
                                 default = nil)
  if valid_589381 != nil:
    section.add "clusterId", valid_589381
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
  section = newJObject()
  var valid_589382 = query.getOrDefault("upload_protocol")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "upload_protocol", valid_589382
  var valid_589383 = query.getOrDefault("fields")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "fields", valid_589383
  var valid_589384 = query.getOrDefault("quotaUser")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "quotaUser", valid_589384
  var valid_589385 = query.getOrDefault("alt")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = newJString("json"))
  if valid_589385 != nil:
    section.add "alt", valid_589385
  var valid_589386 = query.getOrDefault("oauth_token")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "oauth_token", valid_589386
  var valid_589387 = query.getOrDefault("callback")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "callback", valid_589387
  var valid_589388 = query.getOrDefault("access_token")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "access_token", valid_589388
  var valid_589389 = query.getOrDefault("uploadType")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "uploadType", valid_589389
  var valid_589390 = query.getOrDefault("key")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "key", valid_589390
  var valid_589391 = query.getOrDefault("$.xgafv")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = newJString("1"))
  if valid_589391 != nil:
    section.add "$.xgafv", valid_589391
  var valid_589392 = query.getOrDefault("prettyPrint")
  valid_589392 = validateParameter(valid_589392, JBool, required = false,
                                 default = newJBool(true))
  if valid_589392 != nil:
    section.add "prettyPrint", valid_589392
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

proc call*(call_589394: Call_ContainerProjectsZonesClustersNodePoolsSetSize_589375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_589394.validator(path, query, header, formData, body)
  let scheme = call_589394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589394.url(scheme.get, call_589394.host, call_589394.base,
                         call_589394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589394, url, valid)

proc call*(call_589395: Call_ContainerProjectsZonesClustersNodePoolsSetSize_589375;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsSetSize
  ## Sets the size for a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  var path_589396 = newJObject()
  var query_589397 = newJObject()
  var body_589398 = newJObject()
  add(query_589397, "upload_protocol", newJString(uploadProtocol))
  add(path_589396, "zone", newJString(zone))
  add(query_589397, "fields", newJString(fields))
  add(query_589397, "quotaUser", newJString(quotaUser))
  add(query_589397, "alt", newJString(alt))
  add(query_589397, "oauth_token", newJString(oauthToken))
  add(query_589397, "callback", newJString(callback))
  add(query_589397, "access_token", newJString(accessToken))
  add(query_589397, "uploadType", newJString(uploadType))
  add(path_589396, "nodePoolId", newJString(nodePoolId))
  add(query_589397, "key", newJString(key))
  add(path_589396, "projectId", newJString(projectId))
  add(query_589397, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589398 = body
  add(query_589397, "prettyPrint", newJBool(prettyPrint))
  add(path_589396, "clusterId", newJString(clusterId))
  result = call_589395.call(path_589396, query_589397, nil, nil, body_589398)

var containerProjectsZonesClustersNodePoolsSetSize* = Call_ContainerProjectsZonesClustersNodePoolsSetSize_589375(
    name: "containerProjectsZonesClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setSize",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetSize_589376,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetSize_589377,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsUpdate_589399 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsUpdate_589401(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsUpdate_589400(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589402 = path.getOrDefault("zone")
  valid_589402 = validateParameter(valid_589402, JString, required = true,
                                 default = nil)
  if valid_589402 != nil:
    section.add "zone", valid_589402
  var valid_589403 = path.getOrDefault("nodePoolId")
  valid_589403 = validateParameter(valid_589403, JString, required = true,
                                 default = nil)
  if valid_589403 != nil:
    section.add "nodePoolId", valid_589403
  var valid_589404 = path.getOrDefault("projectId")
  valid_589404 = validateParameter(valid_589404, JString, required = true,
                                 default = nil)
  if valid_589404 != nil:
    section.add "projectId", valid_589404
  var valid_589405 = path.getOrDefault("clusterId")
  valid_589405 = validateParameter(valid_589405, JString, required = true,
                                 default = nil)
  if valid_589405 != nil:
    section.add "clusterId", valid_589405
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
  section = newJObject()
  var valid_589406 = query.getOrDefault("upload_protocol")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "upload_protocol", valid_589406
  var valid_589407 = query.getOrDefault("fields")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "fields", valid_589407
  var valid_589408 = query.getOrDefault("quotaUser")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "quotaUser", valid_589408
  var valid_589409 = query.getOrDefault("alt")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = newJString("json"))
  if valid_589409 != nil:
    section.add "alt", valid_589409
  var valid_589410 = query.getOrDefault("oauth_token")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "oauth_token", valid_589410
  var valid_589411 = query.getOrDefault("callback")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "callback", valid_589411
  var valid_589412 = query.getOrDefault("access_token")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "access_token", valid_589412
  var valid_589413 = query.getOrDefault("uploadType")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "uploadType", valid_589413
  var valid_589414 = query.getOrDefault("key")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "key", valid_589414
  var valid_589415 = query.getOrDefault("$.xgafv")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = newJString("1"))
  if valid_589415 != nil:
    section.add "$.xgafv", valid_589415
  var valid_589416 = query.getOrDefault("prettyPrint")
  valid_589416 = validateParameter(valid_589416, JBool, required = false,
                                 default = newJBool(true))
  if valid_589416 != nil:
    section.add "prettyPrint", valid_589416
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

proc call*(call_589418: Call_ContainerProjectsZonesClustersNodePoolsUpdate_589399;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_589418.validator(path, query, header, formData, body)
  let scheme = call_589418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589418.url(scheme.get, call_589418.host, call_589418.base,
                         call_589418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589418, url, valid)

proc call*(call_589419: Call_ContainerProjectsZonesClustersNodePoolsUpdate_589399;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsUpdate
  ## Updates the version and/or image type for the specified node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_589420 = newJObject()
  var query_589421 = newJObject()
  var body_589422 = newJObject()
  add(query_589421, "upload_protocol", newJString(uploadProtocol))
  add(path_589420, "zone", newJString(zone))
  add(query_589421, "fields", newJString(fields))
  add(query_589421, "quotaUser", newJString(quotaUser))
  add(query_589421, "alt", newJString(alt))
  add(query_589421, "oauth_token", newJString(oauthToken))
  add(query_589421, "callback", newJString(callback))
  add(query_589421, "access_token", newJString(accessToken))
  add(query_589421, "uploadType", newJString(uploadType))
  add(path_589420, "nodePoolId", newJString(nodePoolId))
  add(query_589421, "key", newJString(key))
  add(path_589420, "projectId", newJString(projectId))
  add(query_589421, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589422 = body
  add(query_589421, "prettyPrint", newJBool(prettyPrint))
  add(path_589420, "clusterId", newJString(clusterId))
  result = call_589419.call(path_589420, query_589421, nil, nil, body_589422)

var containerProjectsZonesClustersNodePoolsUpdate* = Call_ContainerProjectsZonesClustersNodePoolsUpdate_589399(
    name: "containerProjectsZonesClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/update",
    validator: validate_ContainerProjectsZonesClustersNodePoolsUpdate_589400,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsUpdate_589401,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsRollback_589423 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersNodePoolsRollback_589425(protocol: Scheme;
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersNodePoolsRollback_589424(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to rollback.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to rollback.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589426 = path.getOrDefault("zone")
  valid_589426 = validateParameter(valid_589426, JString, required = true,
                                 default = nil)
  if valid_589426 != nil:
    section.add "zone", valid_589426
  var valid_589427 = path.getOrDefault("nodePoolId")
  valid_589427 = validateParameter(valid_589427, JString, required = true,
                                 default = nil)
  if valid_589427 != nil:
    section.add "nodePoolId", valid_589427
  var valid_589428 = path.getOrDefault("projectId")
  valid_589428 = validateParameter(valid_589428, JString, required = true,
                                 default = nil)
  if valid_589428 != nil:
    section.add "projectId", valid_589428
  var valid_589429 = path.getOrDefault("clusterId")
  valid_589429 = validateParameter(valid_589429, JString, required = true,
                                 default = nil)
  if valid_589429 != nil:
    section.add "clusterId", valid_589429
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
  section = newJObject()
  var valid_589430 = query.getOrDefault("upload_protocol")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "upload_protocol", valid_589430
  var valid_589431 = query.getOrDefault("fields")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "fields", valid_589431
  var valid_589432 = query.getOrDefault("quotaUser")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "quotaUser", valid_589432
  var valid_589433 = query.getOrDefault("alt")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = newJString("json"))
  if valid_589433 != nil:
    section.add "alt", valid_589433
  var valid_589434 = query.getOrDefault("oauth_token")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "oauth_token", valid_589434
  var valid_589435 = query.getOrDefault("callback")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "callback", valid_589435
  var valid_589436 = query.getOrDefault("access_token")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "access_token", valid_589436
  var valid_589437 = query.getOrDefault("uploadType")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "uploadType", valid_589437
  var valid_589438 = query.getOrDefault("key")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "key", valid_589438
  var valid_589439 = query.getOrDefault("$.xgafv")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = newJString("1"))
  if valid_589439 != nil:
    section.add "$.xgafv", valid_589439
  var valid_589440 = query.getOrDefault("prettyPrint")
  valid_589440 = validateParameter(valid_589440, JBool, required = false,
                                 default = newJBool(true))
  if valid_589440 != nil:
    section.add "prettyPrint", valid_589440
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

proc call*(call_589442: Call_ContainerProjectsZonesClustersNodePoolsRollback_589423;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_589442.validator(path, query, header, formData, body)
  let scheme = call_589442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589442.url(scheme.get, call_589442.host, call_589442.base,
                         call_589442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589442, url, valid)

proc call*(call_589443: Call_ContainerProjectsZonesClustersNodePoolsRollback_589423;
          zone: string; nodePoolId: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersNodePoolsRollback
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to rollback.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to rollback.
  ## This field has been deprecated and replaced by the name field.
  var path_589444 = newJObject()
  var query_589445 = newJObject()
  var body_589446 = newJObject()
  add(query_589445, "upload_protocol", newJString(uploadProtocol))
  add(path_589444, "zone", newJString(zone))
  add(query_589445, "fields", newJString(fields))
  add(query_589445, "quotaUser", newJString(quotaUser))
  add(query_589445, "alt", newJString(alt))
  add(query_589445, "oauth_token", newJString(oauthToken))
  add(query_589445, "callback", newJString(callback))
  add(query_589445, "access_token", newJString(accessToken))
  add(query_589445, "uploadType", newJString(uploadType))
  add(path_589444, "nodePoolId", newJString(nodePoolId))
  add(query_589445, "key", newJString(key))
  add(path_589444, "projectId", newJString(projectId))
  add(query_589445, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589446 = body
  add(query_589445, "prettyPrint", newJBool(prettyPrint))
  add(path_589444, "clusterId", newJString(clusterId))
  result = call_589443.call(path_589444, query_589445, nil, nil, body_589446)

var containerProjectsZonesClustersNodePoolsRollback* = Call_ContainerProjectsZonesClustersNodePoolsRollback_589423(
    name: "containerProjectsZonesClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}:rollback",
    validator: validate_ContainerProjectsZonesClustersNodePoolsRollback_589424,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsRollback_589425,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersResourceLabels_589447 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersResourceLabels_589449(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersResourceLabels_589448(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets labels on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589450 = path.getOrDefault("zone")
  valid_589450 = validateParameter(valid_589450, JString, required = true,
                                 default = nil)
  if valid_589450 != nil:
    section.add "zone", valid_589450
  var valid_589451 = path.getOrDefault("projectId")
  valid_589451 = validateParameter(valid_589451, JString, required = true,
                                 default = nil)
  if valid_589451 != nil:
    section.add "projectId", valid_589451
  var valid_589452 = path.getOrDefault("clusterId")
  valid_589452 = validateParameter(valid_589452, JString, required = true,
                                 default = nil)
  if valid_589452 != nil:
    section.add "clusterId", valid_589452
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
  section = newJObject()
  var valid_589453 = query.getOrDefault("upload_protocol")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "upload_protocol", valid_589453
  var valid_589454 = query.getOrDefault("fields")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "fields", valid_589454
  var valid_589455 = query.getOrDefault("quotaUser")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "quotaUser", valid_589455
  var valid_589456 = query.getOrDefault("alt")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = newJString("json"))
  if valid_589456 != nil:
    section.add "alt", valid_589456
  var valid_589457 = query.getOrDefault("oauth_token")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "oauth_token", valid_589457
  var valid_589458 = query.getOrDefault("callback")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "callback", valid_589458
  var valid_589459 = query.getOrDefault("access_token")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "access_token", valid_589459
  var valid_589460 = query.getOrDefault("uploadType")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "uploadType", valid_589460
  var valid_589461 = query.getOrDefault("key")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "key", valid_589461
  var valid_589462 = query.getOrDefault("$.xgafv")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = newJString("1"))
  if valid_589462 != nil:
    section.add "$.xgafv", valid_589462
  var valid_589463 = query.getOrDefault("prettyPrint")
  valid_589463 = validateParameter(valid_589463, JBool, required = false,
                                 default = newJBool(true))
  if valid_589463 != nil:
    section.add "prettyPrint", valid_589463
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

proc call*(call_589465: Call_ContainerProjectsZonesClustersResourceLabels_589447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_589465.validator(path, query, header, formData, body)
  let scheme = call_589465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589465.url(scheme.get, call_589465.host, call_589465.base,
                         call_589465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589465, url, valid)

proc call*(call_589466: Call_ContainerProjectsZonesClustersResourceLabels_589447;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersResourceLabels
  ## Sets labels on a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_589467 = newJObject()
  var query_589468 = newJObject()
  var body_589469 = newJObject()
  add(query_589468, "upload_protocol", newJString(uploadProtocol))
  add(path_589467, "zone", newJString(zone))
  add(query_589468, "fields", newJString(fields))
  add(query_589468, "quotaUser", newJString(quotaUser))
  add(query_589468, "alt", newJString(alt))
  add(query_589468, "oauth_token", newJString(oauthToken))
  add(query_589468, "callback", newJString(callback))
  add(query_589468, "access_token", newJString(accessToken))
  add(query_589468, "uploadType", newJString(uploadType))
  add(query_589468, "key", newJString(key))
  add(path_589467, "projectId", newJString(projectId))
  add(query_589468, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589469 = body
  add(query_589468, "prettyPrint", newJBool(prettyPrint))
  add(path_589467, "clusterId", newJString(clusterId))
  result = call_589466.call(path_589467, query_589468, nil, nil, body_589469)

var containerProjectsZonesClustersResourceLabels* = Call_ContainerProjectsZonesClustersResourceLabels_589447(
    name: "containerProjectsZonesClustersResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/resourceLabels",
    validator: validate_ContainerProjectsZonesClustersResourceLabels_589448,
    base: "/", url: url_ContainerProjectsZonesClustersResourceLabels_589449,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersCompleteIpRotation_589470 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersCompleteIpRotation_589472(
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersCompleteIpRotation_589471(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589473 = path.getOrDefault("zone")
  valid_589473 = validateParameter(valid_589473, JString, required = true,
                                 default = nil)
  if valid_589473 != nil:
    section.add "zone", valid_589473
  var valid_589474 = path.getOrDefault("projectId")
  valid_589474 = validateParameter(valid_589474, JString, required = true,
                                 default = nil)
  if valid_589474 != nil:
    section.add "projectId", valid_589474
  var valid_589475 = path.getOrDefault("clusterId")
  valid_589475 = validateParameter(valid_589475, JString, required = true,
                                 default = nil)
  if valid_589475 != nil:
    section.add "clusterId", valid_589475
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
  section = newJObject()
  var valid_589476 = query.getOrDefault("upload_protocol")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "upload_protocol", valid_589476
  var valid_589477 = query.getOrDefault("fields")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "fields", valid_589477
  var valid_589478 = query.getOrDefault("quotaUser")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "quotaUser", valid_589478
  var valid_589479 = query.getOrDefault("alt")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = newJString("json"))
  if valid_589479 != nil:
    section.add "alt", valid_589479
  var valid_589480 = query.getOrDefault("oauth_token")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "oauth_token", valid_589480
  var valid_589481 = query.getOrDefault("callback")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "callback", valid_589481
  var valid_589482 = query.getOrDefault("access_token")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "access_token", valid_589482
  var valid_589483 = query.getOrDefault("uploadType")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "uploadType", valid_589483
  var valid_589484 = query.getOrDefault("key")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "key", valid_589484
  var valid_589485 = query.getOrDefault("$.xgafv")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = newJString("1"))
  if valid_589485 != nil:
    section.add "$.xgafv", valid_589485
  var valid_589486 = query.getOrDefault("prettyPrint")
  valid_589486 = validateParameter(valid_589486, JBool, required = false,
                                 default = newJBool(true))
  if valid_589486 != nil:
    section.add "prettyPrint", valid_589486
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

proc call*(call_589488: Call_ContainerProjectsZonesClustersCompleteIpRotation_589470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_589488.validator(path, query, header, formData, body)
  let scheme = call_589488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589488.url(scheme.get, call_589488.host, call_589488.base,
                         call_589488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589488, url, valid)

proc call*(call_589489: Call_ContainerProjectsZonesClustersCompleteIpRotation_589470;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_589490 = newJObject()
  var query_589491 = newJObject()
  var body_589492 = newJObject()
  add(query_589491, "upload_protocol", newJString(uploadProtocol))
  add(path_589490, "zone", newJString(zone))
  add(query_589491, "fields", newJString(fields))
  add(query_589491, "quotaUser", newJString(quotaUser))
  add(query_589491, "alt", newJString(alt))
  add(query_589491, "oauth_token", newJString(oauthToken))
  add(query_589491, "callback", newJString(callback))
  add(query_589491, "access_token", newJString(accessToken))
  add(query_589491, "uploadType", newJString(uploadType))
  add(query_589491, "key", newJString(key))
  add(path_589490, "projectId", newJString(projectId))
  add(query_589491, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589492 = body
  add(query_589491, "prettyPrint", newJBool(prettyPrint))
  add(path_589490, "clusterId", newJString(clusterId))
  result = call_589489.call(path_589490, query_589491, nil, nil, body_589492)

var containerProjectsZonesClustersCompleteIpRotation* = Call_ContainerProjectsZonesClustersCompleteIpRotation_589470(
    name: "containerProjectsZonesClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:completeIpRotation",
    validator: validate_ContainerProjectsZonesClustersCompleteIpRotation_589471,
    base: "/", url: url_ContainerProjectsZonesClustersCompleteIpRotation_589472,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMaintenancePolicy_589493 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersSetMaintenancePolicy_589495(
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
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersSetMaintenancePolicy_589494(
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
  var valid_589496 = path.getOrDefault("zone")
  valid_589496 = validateParameter(valid_589496, JString, required = true,
                                 default = nil)
  if valid_589496 != nil:
    section.add "zone", valid_589496
  var valid_589497 = path.getOrDefault("projectId")
  valid_589497 = validateParameter(valid_589497, JString, required = true,
                                 default = nil)
  if valid_589497 != nil:
    section.add "projectId", valid_589497
  var valid_589498 = path.getOrDefault("clusterId")
  valid_589498 = validateParameter(valid_589498, JString, required = true,
                                 default = nil)
  if valid_589498 != nil:
    section.add "clusterId", valid_589498
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
  section = newJObject()
  var valid_589499 = query.getOrDefault("upload_protocol")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "upload_protocol", valid_589499
  var valid_589500 = query.getOrDefault("fields")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "fields", valid_589500
  var valid_589501 = query.getOrDefault("quotaUser")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "quotaUser", valid_589501
  var valid_589502 = query.getOrDefault("alt")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = newJString("json"))
  if valid_589502 != nil:
    section.add "alt", valid_589502
  var valid_589503 = query.getOrDefault("oauth_token")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "oauth_token", valid_589503
  var valid_589504 = query.getOrDefault("callback")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "callback", valid_589504
  var valid_589505 = query.getOrDefault("access_token")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "access_token", valid_589505
  var valid_589506 = query.getOrDefault("uploadType")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "uploadType", valid_589506
  var valid_589507 = query.getOrDefault("key")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "key", valid_589507
  var valid_589508 = query.getOrDefault("$.xgafv")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = newJString("1"))
  if valid_589508 != nil:
    section.add "$.xgafv", valid_589508
  var valid_589509 = query.getOrDefault("prettyPrint")
  valid_589509 = validateParameter(valid_589509, JBool, required = false,
                                 default = newJBool(true))
  if valid_589509 != nil:
    section.add "prettyPrint", valid_589509
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

proc call*(call_589511: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_589493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_589511.validator(path, query, header, formData, body)
  let scheme = call_589511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589511.url(scheme.get, call_589511.host, call_589511.base,
                         call_589511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589511, url, valid)

proc call*(call_589512: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_589493;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  var path_589513 = newJObject()
  var query_589514 = newJObject()
  var body_589515 = newJObject()
  add(query_589514, "upload_protocol", newJString(uploadProtocol))
  add(path_589513, "zone", newJString(zone))
  add(query_589514, "fields", newJString(fields))
  add(query_589514, "quotaUser", newJString(quotaUser))
  add(query_589514, "alt", newJString(alt))
  add(query_589514, "oauth_token", newJString(oauthToken))
  add(query_589514, "callback", newJString(callback))
  add(query_589514, "access_token", newJString(accessToken))
  add(query_589514, "uploadType", newJString(uploadType))
  add(query_589514, "key", newJString(key))
  add(path_589513, "projectId", newJString(projectId))
  add(query_589514, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589515 = body
  add(query_589514, "prettyPrint", newJBool(prettyPrint))
  add(path_589513, "clusterId", newJString(clusterId))
  result = call_589512.call(path_589513, query_589514, nil, nil, body_589515)

var containerProjectsZonesClustersSetMaintenancePolicy* = Call_ContainerProjectsZonesClustersSetMaintenancePolicy_589493(
    name: "containerProjectsZonesClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMaintenancePolicy",
    validator: validate_ContainerProjectsZonesClustersSetMaintenancePolicy_589494,
    base: "/", url: url_ContainerProjectsZonesClustersSetMaintenancePolicy_589495,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMasterAuth_589516 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersSetMasterAuth_589518(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersSetMasterAuth_589517(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589519 = path.getOrDefault("zone")
  valid_589519 = validateParameter(valid_589519, JString, required = true,
                                 default = nil)
  if valid_589519 != nil:
    section.add "zone", valid_589519
  var valid_589520 = path.getOrDefault("projectId")
  valid_589520 = validateParameter(valid_589520, JString, required = true,
                                 default = nil)
  if valid_589520 != nil:
    section.add "projectId", valid_589520
  var valid_589521 = path.getOrDefault("clusterId")
  valid_589521 = validateParameter(valid_589521, JString, required = true,
                                 default = nil)
  if valid_589521 != nil:
    section.add "clusterId", valid_589521
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
  section = newJObject()
  var valid_589522 = query.getOrDefault("upload_protocol")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "upload_protocol", valid_589522
  var valid_589523 = query.getOrDefault("fields")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "fields", valid_589523
  var valid_589524 = query.getOrDefault("quotaUser")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "quotaUser", valid_589524
  var valid_589525 = query.getOrDefault("alt")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = newJString("json"))
  if valid_589525 != nil:
    section.add "alt", valid_589525
  var valid_589526 = query.getOrDefault("oauth_token")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "oauth_token", valid_589526
  var valid_589527 = query.getOrDefault("callback")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "callback", valid_589527
  var valid_589528 = query.getOrDefault("access_token")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "access_token", valid_589528
  var valid_589529 = query.getOrDefault("uploadType")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "uploadType", valid_589529
  var valid_589530 = query.getOrDefault("key")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = nil)
  if valid_589530 != nil:
    section.add "key", valid_589530
  var valid_589531 = query.getOrDefault("$.xgafv")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = newJString("1"))
  if valid_589531 != nil:
    section.add "$.xgafv", valid_589531
  var valid_589532 = query.getOrDefault("prettyPrint")
  valid_589532 = validateParameter(valid_589532, JBool, required = false,
                                 default = newJBool(true))
  if valid_589532 != nil:
    section.add "prettyPrint", valid_589532
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

proc call*(call_589534: Call_ContainerProjectsZonesClustersSetMasterAuth_589516;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_589534.validator(path, query, header, formData, body)
  let scheme = call_589534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589534.url(scheme.get, call_589534.host, call_589534.base,
                         call_589534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589534, url, valid)

proc call*(call_589535: Call_ContainerProjectsZonesClustersSetMasterAuth_589516;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersSetMasterAuth
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  var path_589536 = newJObject()
  var query_589537 = newJObject()
  var body_589538 = newJObject()
  add(query_589537, "upload_protocol", newJString(uploadProtocol))
  add(path_589536, "zone", newJString(zone))
  add(query_589537, "fields", newJString(fields))
  add(query_589537, "quotaUser", newJString(quotaUser))
  add(query_589537, "alt", newJString(alt))
  add(query_589537, "oauth_token", newJString(oauthToken))
  add(query_589537, "callback", newJString(callback))
  add(query_589537, "access_token", newJString(accessToken))
  add(query_589537, "uploadType", newJString(uploadType))
  add(query_589537, "key", newJString(key))
  add(path_589536, "projectId", newJString(projectId))
  add(query_589537, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589538 = body
  add(query_589537, "prettyPrint", newJBool(prettyPrint))
  add(path_589536, "clusterId", newJString(clusterId))
  result = call_589535.call(path_589536, query_589537, nil, nil, body_589538)

var containerProjectsZonesClustersSetMasterAuth* = Call_ContainerProjectsZonesClustersSetMasterAuth_589516(
    name: "containerProjectsZonesClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMasterAuth",
    validator: validate_ContainerProjectsZonesClustersSetMasterAuth_589517,
    base: "/", url: url_ContainerProjectsZonesClustersSetMasterAuth_589518,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetNetworkPolicy_589539 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersSetNetworkPolicy_589541(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersSetNetworkPolicy_589540(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables or disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589542 = path.getOrDefault("zone")
  valid_589542 = validateParameter(valid_589542, JString, required = true,
                                 default = nil)
  if valid_589542 != nil:
    section.add "zone", valid_589542
  var valid_589543 = path.getOrDefault("projectId")
  valid_589543 = validateParameter(valid_589543, JString, required = true,
                                 default = nil)
  if valid_589543 != nil:
    section.add "projectId", valid_589543
  var valid_589544 = path.getOrDefault("clusterId")
  valid_589544 = validateParameter(valid_589544, JString, required = true,
                                 default = nil)
  if valid_589544 != nil:
    section.add "clusterId", valid_589544
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
  section = newJObject()
  var valid_589545 = query.getOrDefault("upload_protocol")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "upload_protocol", valid_589545
  var valid_589546 = query.getOrDefault("fields")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "fields", valid_589546
  var valid_589547 = query.getOrDefault("quotaUser")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "quotaUser", valid_589547
  var valid_589548 = query.getOrDefault("alt")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = newJString("json"))
  if valid_589548 != nil:
    section.add "alt", valid_589548
  var valid_589549 = query.getOrDefault("oauth_token")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "oauth_token", valid_589549
  var valid_589550 = query.getOrDefault("callback")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = nil)
  if valid_589550 != nil:
    section.add "callback", valid_589550
  var valid_589551 = query.getOrDefault("access_token")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "access_token", valid_589551
  var valid_589552 = query.getOrDefault("uploadType")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "uploadType", valid_589552
  var valid_589553 = query.getOrDefault("key")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "key", valid_589553
  var valid_589554 = query.getOrDefault("$.xgafv")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = newJString("1"))
  if valid_589554 != nil:
    section.add "$.xgafv", valid_589554
  var valid_589555 = query.getOrDefault("prettyPrint")
  valid_589555 = validateParameter(valid_589555, JBool, required = false,
                                 default = newJBool(true))
  if valid_589555 != nil:
    section.add "prettyPrint", valid_589555
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

proc call*(call_589557: Call_ContainerProjectsZonesClustersSetNetworkPolicy_589539;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_589557.validator(path, query, header, formData, body)
  let scheme = call_589557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589557.url(scheme.get, call_589557.host, call_589557.base,
                         call_589557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589557, url, valid)

proc call*(call_589558: Call_ContainerProjectsZonesClustersSetNetworkPolicy_589539;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersSetNetworkPolicy
  ## Enables or disables Network Policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_589559 = newJObject()
  var query_589560 = newJObject()
  var body_589561 = newJObject()
  add(query_589560, "upload_protocol", newJString(uploadProtocol))
  add(path_589559, "zone", newJString(zone))
  add(query_589560, "fields", newJString(fields))
  add(query_589560, "quotaUser", newJString(quotaUser))
  add(query_589560, "alt", newJString(alt))
  add(query_589560, "oauth_token", newJString(oauthToken))
  add(query_589560, "callback", newJString(callback))
  add(query_589560, "access_token", newJString(accessToken))
  add(query_589560, "uploadType", newJString(uploadType))
  add(query_589560, "key", newJString(key))
  add(path_589559, "projectId", newJString(projectId))
  add(query_589560, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589561 = body
  add(query_589560, "prettyPrint", newJBool(prettyPrint))
  add(path_589559, "clusterId", newJString(clusterId))
  result = call_589558.call(path_589559, query_589560, nil, nil, body_589561)

var containerProjectsZonesClustersSetNetworkPolicy* = Call_ContainerProjectsZonesClustersSetNetworkPolicy_589539(
    name: "containerProjectsZonesClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setNetworkPolicy",
    validator: validate_ContainerProjectsZonesClustersSetNetworkPolicy_589540,
    base: "/", url: url_ContainerProjectsZonesClustersSetNetworkPolicy_589541,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersStartIpRotation_589562 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesClustersStartIpRotation_589564(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesClustersStartIpRotation_589563(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589565 = path.getOrDefault("zone")
  valid_589565 = validateParameter(valid_589565, JString, required = true,
                                 default = nil)
  if valid_589565 != nil:
    section.add "zone", valid_589565
  var valid_589566 = path.getOrDefault("projectId")
  valid_589566 = validateParameter(valid_589566, JString, required = true,
                                 default = nil)
  if valid_589566 != nil:
    section.add "projectId", valid_589566
  var valid_589567 = path.getOrDefault("clusterId")
  valid_589567 = validateParameter(valid_589567, JString, required = true,
                                 default = nil)
  if valid_589567 != nil:
    section.add "clusterId", valid_589567
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
  section = newJObject()
  var valid_589568 = query.getOrDefault("upload_protocol")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = nil)
  if valid_589568 != nil:
    section.add "upload_protocol", valid_589568
  var valid_589569 = query.getOrDefault("fields")
  valid_589569 = validateParameter(valid_589569, JString, required = false,
                                 default = nil)
  if valid_589569 != nil:
    section.add "fields", valid_589569
  var valid_589570 = query.getOrDefault("quotaUser")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = nil)
  if valid_589570 != nil:
    section.add "quotaUser", valid_589570
  var valid_589571 = query.getOrDefault("alt")
  valid_589571 = validateParameter(valid_589571, JString, required = false,
                                 default = newJString("json"))
  if valid_589571 != nil:
    section.add "alt", valid_589571
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

proc call*(call_589580: Call_ContainerProjectsZonesClustersStartIpRotation_589562;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_589580.validator(path, query, header, formData, body)
  let scheme = call_589580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589580.url(scheme.get, call_589580.host, call_589580.base,
                         call_589580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589580, url, valid)

proc call*(call_589581: Call_ContainerProjectsZonesClustersStartIpRotation_589562;
          zone: string; projectId: string; clusterId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesClustersStartIpRotation
  ## Starts master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_589582 = newJObject()
  var query_589583 = newJObject()
  var body_589584 = newJObject()
  add(query_589583, "upload_protocol", newJString(uploadProtocol))
  add(path_589582, "zone", newJString(zone))
  add(query_589583, "fields", newJString(fields))
  add(query_589583, "quotaUser", newJString(quotaUser))
  add(query_589583, "alt", newJString(alt))
  add(query_589583, "oauth_token", newJString(oauthToken))
  add(query_589583, "callback", newJString(callback))
  add(query_589583, "access_token", newJString(accessToken))
  add(query_589583, "uploadType", newJString(uploadType))
  add(query_589583, "key", newJString(key))
  add(path_589582, "projectId", newJString(projectId))
  add(query_589583, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589584 = body
  add(query_589583, "prettyPrint", newJBool(prettyPrint))
  add(path_589582, "clusterId", newJString(clusterId))
  result = call_589581.call(path_589582, query_589583, nil, nil, body_589584)

var containerProjectsZonesClustersStartIpRotation* = Call_ContainerProjectsZonesClustersStartIpRotation_589562(
    name: "containerProjectsZonesClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:startIpRotation",
    validator: validate_ContainerProjectsZonesClustersStartIpRotation_589563,
    base: "/", url: url_ContainerProjectsZonesClustersStartIpRotation_589564,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsList_589585 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesOperationsList_589587(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsList_589586(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589588 = path.getOrDefault("zone")
  valid_589588 = validateParameter(valid_589588, JString, required = true,
                                 default = nil)
  if valid_589588 != nil:
    section.add "zone", valid_589588
  var valid_589589 = path.getOrDefault("projectId")
  valid_589589 = validateParameter(valid_589589, JString, required = true,
                                 default = nil)
  if valid_589589 != nil:
    section.add "projectId", valid_589589
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
  section = newJObject()
  var valid_589590 = query.getOrDefault("upload_protocol")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = nil)
  if valid_589590 != nil:
    section.add "upload_protocol", valid_589590
  var valid_589591 = query.getOrDefault("fields")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "fields", valid_589591
  var valid_589592 = query.getOrDefault("quotaUser")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "quotaUser", valid_589592
  var valid_589593 = query.getOrDefault("alt")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = newJString("json"))
  if valid_589593 != nil:
    section.add "alt", valid_589593
  var valid_589594 = query.getOrDefault("oauth_token")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "oauth_token", valid_589594
  var valid_589595 = query.getOrDefault("callback")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "callback", valid_589595
  var valid_589596 = query.getOrDefault("access_token")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = nil)
  if valid_589596 != nil:
    section.add "access_token", valid_589596
  var valid_589597 = query.getOrDefault("uploadType")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "uploadType", valid_589597
  var valid_589598 = query.getOrDefault("parent")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = nil)
  if valid_589598 != nil:
    section.add "parent", valid_589598
  var valid_589599 = query.getOrDefault("key")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "key", valid_589599
  var valid_589600 = query.getOrDefault("$.xgafv")
  valid_589600 = validateParameter(valid_589600, JString, required = false,
                                 default = newJString("1"))
  if valid_589600 != nil:
    section.add "$.xgafv", valid_589600
  var valid_589601 = query.getOrDefault("prettyPrint")
  valid_589601 = validateParameter(valid_589601, JBool, required = false,
                                 default = newJBool(true))
  if valid_589601 != nil:
    section.add "prettyPrint", valid_589601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589602: Call_ContainerProjectsZonesOperationsList_589585;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_589602.validator(path, query, header, formData, body)
  let scheme = call_589602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589602.url(scheme.get, call_589602.host, call_589602.base,
                         call_589602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589602, url, valid)

proc call*(call_589603: Call_ContainerProjectsZonesOperationsList_589585;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; parent: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589604 = newJObject()
  var query_589605 = newJObject()
  add(query_589605, "upload_protocol", newJString(uploadProtocol))
  add(path_589604, "zone", newJString(zone))
  add(query_589605, "fields", newJString(fields))
  add(query_589605, "quotaUser", newJString(quotaUser))
  add(query_589605, "alt", newJString(alt))
  add(query_589605, "oauth_token", newJString(oauthToken))
  add(query_589605, "callback", newJString(callback))
  add(query_589605, "access_token", newJString(accessToken))
  add(query_589605, "uploadType", newJString(uploadType))
  add(query_589605, "parent", newJString(parent))
  add(query_589605, "key", newJString(key))
  add(path_589604, "projectId", newJString(projectId))
  add(query_589605, "$.xgafv", newJString(Xgafv))
  add(query_589605, "prettyPrint", newJBool(prettyPrint))
  result = call_589603.call(path_589604, query_589605, nil, nil, nil)

var containerProjectsZonesOperationsList* = Call_ContainerProjectsZonesOperationsList_589585(
    name: "containerProjectsZonesOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations",
    validator: validate_ContainerProjectsZonesOperationsList_589586, base: "/",
    url: url_ContainerProjectsZonesOperationsList_589587, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsGet_589606 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesOperationsGet_589608(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsGet_589607(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   operationId: JString (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589609 = path.getOrDefault("zone")
  valid_589609 = validateParameter(valid_589609, JString, required = true,
                                 default = nil)
  if valid_589609 != nil:
    section.add "zone", valid_589609
  var valid_589610 = path.getOrDefault("projectId")
  valid_589610 = validateParameter(valid_589610, JString, required = true,
                                 default = nil)
  if valid_589610 != nil:
    section.add "projectId", valid_589610
  var valid_589611 = path.getOrDefault("operationId")
  valid_589611 = validateParameter(valid_589611, JString, required = true,
                                 default = nil)
  if valid_589611 != nil:
    section.add "operationId", valid_589611
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
  section = newJObject()
  var valid_589612 = query.getOrDefault("upload_protocol")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "upload_protocol", valid_589612
  var valid_589613 = query.getOrDefault("fields")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "fields", valid_589613
  var valid_589614 = query.getOrDefault("quotaUser")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "quotaUser", valid_589614
  var valid_589615 = query.getOrDefault("alt")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = newJString("json"))
  if valid_589615 != nil:
    section.add "alt", valid_589615
  var valid_589616 = query.getOrDefault("oauth_token")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = nil)
  if valid_589616 != nil:
    section.add "oauth_token", valid_589616
  var valid_589617 = query.getOrDefault("callback")
  valid_589617 = validateParameter(valid_589617, JString, required = false,
                                 default = nil)
  if valid_589617 != nil:
    section.add "callback", valid_589617
  var valid_589618 = query.getOrDefault("access_token")
  valid_589618 = validateParameter(valid_589618, JString, required = false,
                                 default = nil)
  if valid_589618 != nil:
    section.add "access_token", valid_589618
  var valid_589619 = query.getOrDefault("uploadType")
  valid_589619 = validateParameter(valid_589619, JString, required = false,
                                 default = nil)
  if valid_589619 != nil:
    section.add "uploadType", valid_589619
  var valid_589620 = query.getOrDefault("key")
  valid_589620 = validateParameter(valid_589620, JString, required = false,
                                 default = nil)
  if valid_589620 != nil:
    section.add "key", valid_589620
  var valid_589621 = query.getOrDefault("name")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = nil)
  if valid_589621 != nil:
    section.add "name", valid_589621
  var valid_589622 = query.getOrDefault("$.xgafv")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = newJString("1"))
  if valid_589622 != nil:
    section.add "$.xgafv", valid_589622
  var valid_589623 = query.getOrDefault("prettyPrint")
  valid_589623 = validateParameter(valid_589623, JBool, required = false,
                                 default = newJBool(true))
  if valid_589623 != nil:
    section.add "prettyPrint", valid_589623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589624: Call_ContainerProjectsZonesOperationsGet_589606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified operation.
  ## 
  let valid = call_589624.validator(path, query, header, formData, body)
  let scheme = call_589624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589624.url(scheme.get, call_589624.host, call_589624.base,
                         call_589624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589624, url, valid)

proc call*(call_589625: Call_ContainerProjectsZonesOperationsGet_589606;
          zone: string; projectId: string; operationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesOperationsGet
  ## Gets the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   operationId: string (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  var path_589626 = newJObject()
  var query_589627 = newJObject()
  add(query_589627, "upload_protocol", newJString(uploadProtocol))
  add(path_589626, "zone", newJString(zone))
  add(query_589627, "fields", newJString(fields))
  add(query_589627, "quotaUser", newJString(quotaUser))
  add(query_589627, "alt", newJString(alt))
  add(query_589627, "oauth_token", newJString(oauthToken))
  add(query_589627, "callback", newJString(callback))
  add(query_589627, "access_token", newJString(accessToken))
  add(query_589627, "uploadType", newJString(uploadType))
  add(query_589627, "key", newJString(key))
  add(query_589627, "name", newJString(name))
  add(path_589626, "projectId", newJString(projectId))
  add(query_589627, "$.xgafv", newJString(Xgafv))
  add(query_589627, "prettyPrint", newJBool(prettyPrint))
  add(path_589626, "operationId", newJString(operationId))
  result = call_589625.call(path_589626, query_589627, nil, nil, nil)

var containerProjectsZonesOperationsGet* = Call_ContainerProjectsZonesOperationsGet_589606(
    name: "containerProjectsZonesOperationsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}",
    validator: validate_ContainerProjectsZonesOperationsGet_589607, base: "/",
    url: url_ContainerProjectsZonesOperationsGet_589608, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsCancel_589628 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesOperationsCancel_589630(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
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

proc validate_ContainerProjectsZonesOperationsCancel_589629(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   operationId: JString (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589631 = path.getOrDefault("zone")
  valid_589631 = validateParameter(valid_589631, JString, required = true,
                                 default = nil)
  if valid_589631 != nil:
    section.add "zone", valid_589631
  var valid_589632 = path.getOrDefault("projectId")
  valid_589632 = validateParameter(valid_589632, JString, required = true,
                                 default = nil)
  if valid_589632 != nil:
    section.add "projectId", valid_589632
  var valid_589633 = path.getOrDefault("operationId")
  valid_589633 = validateParameter(valid_589633, JString, required = true,
                                 default = nil)
  if valid_589633 != nil:
    section.add "operationId", valid_589633
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
  section = newJObject()
  var valid_589634 = query.getOrDefault("upload_protocol")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = nil)
  if valid_589634 != nil:
    section.add "upload_protocol", valid_589634
  var valid_589635 = query.getOrDefault("fields")
  valid_589635 = validateParameter(valid_589635, JString, required = false,
                                 default = nil)
  if valid_589635 != nil:
    section.add "fields", valid_589635
  var valid_589636 = query.getOrDefault("quotaUser")
  valid_589636 = validateParameter(valid_589636, JString, required = false,
                                 default = nil)
  if valid_589636 != nil:
    section.add "quotaUser", valid_589636
  var valid_589637 = query.getOrDefault("alt")
  valid_589637 = validateParameter(valid_589637, JString, required = false,
                                 default = newJString("json"))
  if valid_589637 != nil:
    section.add "alt", valid_589637
  var valid_589638 = query.getOrDefault("oauth_token")
  valid_589638 = validateParameter(valid_589638, JString, required = false,
                                 default = nil)
  if valid_589638 != nil:
    section.add "oauth_token", valid_589638
  var valid_589639 = query.getOrDefault("callback")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = nil)
  if valid_589639 != nil:
    section.add "callback", valid_589639
  var valid_589640 = query.getOrDefault("access_token")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "access_token", valid_589640
  var valid_589641 = query.getOrDefault("uploadType")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "uploadType", valid_589641
  var valid_589642 = query.getOrDefault("key")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "key", valid_589642
  var valid_589643 = query.getOrDefault("$.xgafv")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = newJString("1"))
  if valid_589643 != nil:
    section.add "$.xgafv", valid_589643
  var valid_589644 = query.getOrDefault("prettyPrint")
  valid_589644 = validateParameter(valid_589644, JBool, required = false,
                                 default = newJBool(true))
  if valid_589644 != nil:
    section.add "prettyPrint", valid_589644
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

proc call*(call_589646: Call_ContainerProjectsZonesOperationsCancel_589628;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_589646.validator(path, query, header, formData, body)
  let scheme = call_589646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589646.url(scheme.get, call_589646.host, call_589646.base,
                         call_589646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589646, url, valid)

proc call*(call_589647: Call_ContainerProjectsZonesOperationsCancel_589628;
          zone: string; projectId: string; operationId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesOperationsCancel
  ## Cancels the specified operation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   operationId: string (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  var path_589648 = newJObject()
  var query_589649 = newJObject()
  var body_589650 = newJObject()
  add(query_589649, "upload_protocol", newJString(uploadProtocol))
  add(path_589648, "zone", newJString(zone))
  add(query_589649, "fields", newJString(fields))
  add(query_589649, "quotaUser", newJString(quotaUser))
  add(query_589649, "alt", newJString(alt))
  add(query_589649, "oauth_token", newJString(oauthToken))
  add(query_589649, "callback", newJString(callback))
  add(query_589649, "access_token", newJString(accessToken))
  add(query_589649, "uploadType", newJString(uploadType))
  add(query_589649, "key", newJString(key))
  add(path_589648, "projectId", newJString(projectId))
  add(query_589649, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589650 = body
  add(query_589649, "prettyPrint", newJBool(prettyPrint))
  add(path_589648, "operationId", newJString(operationId))
  result = call_589647.call(path_589648, query_589649, nil, nil, body_589650)

var containerProjectsZonesOperationsCancel* = Call_ContainerProjectsZonesOperationsCancel_589628(
    name: "containerProjectsZonesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}:cancel",
    validator: validate_ContainerProjectsZonesOperationsCancel_589629, base: "/",
    url: url_ContainerProjectsZonesOperationsCancel_589630,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesGetServerconfig_589651 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsZonesGetServerconfig_589653(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/serverconfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsZonesGetServerconfig_589652(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589654 = path.getOrDefault("zone")
  valid_589654 = validateParameter(valid_589654, JString, required = true,
                                 default = nil)
  if valid_589654 != nil:
    section.add "zone", valid_589654
  var valid_589655 = path.getOrDefault("projectId")
  valid_589655 = validateParameter(valid_589655, JString, required = true,
                                 default = nil)
  if valid_589655 != nil:
    section.add "projectId", valid_589655
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
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589656 = query.getOrDefault("upload_protocol")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "upload_protocol", valid_589656
  var valid_589657 = query.getOrDefault("fields")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "fields", valid_589657
  var valid_589658 = query.getOrDefault("quotaUser")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = nil)
  if valid_589658 != nil:
    section.add "quotaUser", valid_589658
  var valid_589659 = query.getOrDefault("alt")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = newJString("json"))
  if valid_589659 != nil:
    section.add "alt", valid_589659
  var valid_589660 = query.getOrDefault("oauth_token")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "oauth_token", valid_589660
  var valid_589661 = query.getOrDefault("callback")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "callback", valid_589661
  var valid_589662 = query.getOrDefault("access_token")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "access_token", valid_589662
  var valid_589663 = query.getOrDefault("uploadType")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "uploadType", valid_589663
  var valid_589664 = query.getOrDefault("key")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "key", valid_589664
  var valid_589665 = query.getOrDefault("name")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "name", valid_589665
  var valid_589666 = query.getOrDefault("$.xgafv")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = newJString("1"))
  if valid_589666 != nil:
    section.add "$.xgafv", valid_589666
  var valid_589667 = query.getOrDefault("prettyPrint")
  valid_589667 = validateParameter(valid_589667, JBool, required = false,
                                 default = newJBool(true))
  if valid_589667 != nil:
    section.add "prettyPrint", valid_589667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589668: Call_ContainerProjectsZonesGetServerconfig_589651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_589668.validator(path, query, header, formData, body)
  let scheme = call_589668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589668.url(scheme.get, call_589668.host, call_589668.base,
                         call_589668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589668, url, valid)

proc call*(call_589669: Call_ContainerProjectsZonesGetServerconfig_589651;
          zone: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; name: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## containerProjectsZonesGetServerconfig
  ## Returns configuration info about the Google Kubernetes Engine service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589670 = newJObject()
  var query_589671 = newJObject()
  add(query_589671, "upload_protocol", newJString(uploadProtocol))
  add(path_589670, "zone", newJString(zone))
  add(query_589671, "fields", newJString(fields))
  add(query_589671, "quotaUser", newJString(quotaUser))
  add(query_589671, "alt", newJString(alt))
  add(query_589671, "oauth_token", newJString(oauthToken))
  add(query_589671, "callback", newJString(callback))
  add(query_589671, "access_token", newJString(accessToken))
  add(query_589671, "uploadType", newJString(uploadType))
  add(query_589671, "key", newJString(key))
  add(query_589671, "name", newJString(name))
  add(path_589670, "projectId", newJString(projectId))
  add(query_589671, "$.xgafv", newJString(Xgafv))
  add(query_589671, "prettyPrint", newJBool(prettyPrint))
  result = call_589669.call(path_589670, query_589671, nil, nil, nil)

var containerProjectsZonesGetServerconfig* = Call_ContainerProjectsZonesGetServerconfig_589651(
    name: "containerProjectsZonesGetServerconfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/serverconfig",
    validator: validate_ContainerProjectsZonesGetServerconfig_589652, base: "/",
    url: url_ContainerProjectsZonesGetServerconfig_589653, schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsUpdate_589695 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsUpdate_589697(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsUpdate_589696(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to
  ## update. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589698 = path.getOrDefault("name")
  valid_589698 = validateParameter(valid_589698, JString, required = true,
                                 default = nil)
  if valid_589698 != nil:
    section.add "name", valid_589698
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
  section = newJObject()
  var valid_589699 = query.getOrDefault("upload_protocol")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = nil)
  if valid_589699 != nil:
    section.add "upload_protocol", valid_589699
  var valid_589700 = query.getOrDefault("fields")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = nil)
  if valid_589700 != nil:
    section.add "fields", valid_589700
  var valid_589701 = query.getOrDefault("quotaUser")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = nil)
  if valid_589701 != nil:
    section.add "quotaUser", valid_589701
  var valid_589702 = query.getOrDefault("alt")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = newJString("json"))
  if valid_589702 != nil:
    section.add "alt", valid_589702
  var valid_589703 = query.getOrDefault("oauth_token")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "oauth_token", valid_589703
  var valid_589704 = query.getOrDefault("callback")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = nil)
  if valid_589704 != nil:
    section.add "callback", valid_589704
  var valid_589705 = query.getOrDefault("access_token")
  valid_589705 = validateParameter(valid_589705, JString, required = false,
                                 default = nil)
  if valid_589705 != nil:
    section.add "access_token", valid_589705
  var valid_589706 = query.getOrDefault("uploadType")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = nil)
  if valid_589706 != nil:
    section.add "uploadType", valid_589706
  var valid_589707 = query.getOrDefault("key")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "key", valid_589707
  var valid_589708 = query.getOrDefault("$.xgafv")
  valid_589708 = validateParameter(valid_589708, JString, required = false,
                                 default = newJString("1"))
  if valid_589708 != nil:
    section.add "$.xgafv", valid_589708
  var valid_589709 = query.getOrDefault("prettyPrint")
  valid_589709 = validateParameter(valid_589709, JBool, required = false,
                                 default = newJBool(true))
  if valid_589709 != nil:
    section.add "prettyPrint", valid_589709
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

proc call*(call_589711: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_589695;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_589711.validator(path, query, header, formData, body)
  let scheme = call_589711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589711.url(scheme.get, call_589711.host, call_589711.base,
                         call_589711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589711, url, valid)

proc call*(call_589712: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_589695;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersNodePoolsUpdate
  ## Updates the version and/or image type for the specified node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to
  ## update. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_589713 = newJObject()
  var query_589714 = newJObject()
  var body_589715 = newJObject()
  add(query_589714, "upload_protocol", newJString(uploadProtocol))
  add(query_589714, "fields", newJString(fields))
  add(query_589714, "quotaUser", newJString(quotaUser))
  add(path_589713, "name", newJString(name))
  add(query_589714, "alt", newJString(alt))
  add(query_589714, "oauth_token", newJString(oauthToken))
  add(query_589714, "callback", newJString(callback))
  add(query_589714, "access_token", newJString(accessToken))
  add(query_589714, "uploadType", newJString(uploadType))
  add(query_589714, "key", newJString(key))
  add(query_589714, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589715 = body
  add(query_589714, "prettyPrint", newJBool(prettyPrint))
  result = call_589712.call(path_589713, query_589714, nil, nil, body_589715)

var containerProjectsLocationsClustersNodePoolsUpdate* = Call_ContainerProjectsLocationsClustersNodePoolsUpdate_589695(
    name: "containerProjectsLocationsClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPut, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsUpdate_589696,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsUpdate_589697,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsGet_589672 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsGet_589674(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsGet_589673(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the requested node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589675 = path.getOrDefault("name")
  valid_589675 = validateParameter(valid_589675, JString, required = true,
                                 default = nil)
  if valid_589675 != nil:
    section.add "name", valid_589675
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: JString
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  var valid_589676 = query.getOrDefault("upload_protocol")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = nil)
  if valid_589676 != nil:
    section.add "upload_protocol", valid_589676
  var valid_589677 = query.getOrDefault("fields")
  valid_589677 = validateParameter(valid_589677, JString, required = false,
                                 default = nil)
  if valid_589677 != nil:
    section.add "fields", valid_589677
  var valid_589678 = query.getOrDefault("quotaUser")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "quotaUser", valid_589678
  var valid_589679 = query.getOrDefault("alt")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = newJString("json"))
  if valid_589679 != nil:
    section.add "alt", valid_589679
  var valid_589680 = query.getOrDefault("oauth_token")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "oauth_token", valid_589680
  var valid_589681 = query.getOrDefault("callback")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = nil)
  if valid_589681 != nil:
    section.add "callback", valid_589681
  var valid_589682 = query.getOrDefault("access_token")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "access_token", valid_589682
  var valid_589683 = query.getOrDefault("uploadType")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = nil)
  if valid_589683 != nil:
    section.add "uploadType", valid_589683
  var valid_589684 = query.getOrDefault("nodePoolId")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "nodePoolId", valid_589684
  var valid_589685 = query.getOrDefault("zone")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = nil)
  if valid_589685 != nil:
    section.add "zone", valid_589685
  var valid_589686 = query.getOrDefault("key")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "key", valid_589686
  var valid_589687 = query.getOrDefault("$.xgafv")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = newJString("1"))
  if valid_589687 != nil:
    section.add "$.xgafv", valid_589687
  var valid_589688 = query.getOrDefault("projectId")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = nil)
  if valid_589688 != nil:
    section.add "projectId", valid_589688
  var valid_589689 = query.getOrDefault("prettyPrint")
  valid_589689 = validateParameter(valid_589689, JBool, required = false,
                                 default = newJBool(true))
  if valid_589689 != nil:
    section.add "prettyPrint", valid_589689
  var valid_589690 = query.getOrDefault("clusterId")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = nil)
  if valid_589690 != nil:
    section.add "clusterId", valid_589690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589691: Call_ContainerProjectsLocationsClustersNodePoolsGet_589672;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_589691.validator(path, query, header, formData, body)
  let scheme = call_589691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589691.url(scheme.get, call_589691.host, call_589691.base,
                         call_589691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589691, url, valid)

proc call*(call_589692: Call_ContainerProjectsLocationsClustersNodePoolsGet_589672;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          nodePoolId: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; clusterId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsGet
  ## Retrieves the requested node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_589693 = newJObject()
  var query_589694 = newJObject()
  add(query_589694, "upload_protocol", newJString(uploadProtocol))
  add(query_589694, "fields", newJString(fields))
  add(query_589694, "quotaUser", newJString(quotaUser))
  add(path_589693, "name", newJString(name))
  add(query_589694, "alt", newJString(alt))
  add(query_589694, "oauth_token", newJString(oauthToken))
  add(query_589694, "callback", newJString(callback))
  add(query_589694, "access_token", newJString(accessToken))
  add(query_589694, "uploadType", newJString(uploadType))
  add(query_589694, "nodePoolId", newJString(nodePoolId))
  add(query_589694, "zone", newJString(zone))
  add(query_589694, "key", newJString(key))
  add(query_589694, "$.xgafv", newJString(Xgafv))
  add(query_589694, "projectId", newJString(projectId))
  add(query_589694, "prettyPrint", newJBool(prettyPrint))
  add(query_589694, "clusterId", newJString(clusterId))
  result = call_589692.call(path_589693, query_589694, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsGet* = Call_ContainerProjectsLocationsClustersNodePoolsGet_589672(
    name: "containerProjectsLocationsClustersNodePoolsGet",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsGet_589673,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsGet_589674,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsDelete_589716 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsDelete_589718(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsDelete_589717(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589719 = path.getOrDefault("name")
  valid_589719 = validateParameter(valid_589719, JString, required = true,
                                 default = nil)
  if valid_589719 != nil:
    section.add "name", valid_589719
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: JString
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  var valid_589720 = query.getOrDefault("upload_protocol")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "upload_protocol", valid_589720
  var valid_589721 = query.getOrDefault("fields")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "fields", valid_589721
  var valid_589722 = query.getOrDefault("quotaUser")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "quotaUser", valid_589722
  var valid_589723 = query.getOrDefault("alt")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = newJString("json"))
  if valid_589723 != nil:
    section.add "alt", valid_589723
  var valid_589724 = query.getOrDefault("oauth_token")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "oauth_token", valid_589724
  var valid_589725 = query.getOrDefault("callback")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "callback", valid_589725
  var valid_589726 = query.getOrDefault("access_token")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = nil)
  if valid_589726 != nil:
    section.add "access_token", valid_589726
  var valid_589727 = query.getOrDefault("uploadType")
  valid_589727 = validateParameter(valid_589727, JString, required = false,
                                 default = nil)
  if valid_589727 != nil:
    section.add "uploadType", valid_589727
  var valid_589728 = query.getOrDefault("nodePoolId")
  valid_589728 = validateParameter(valid_589728, JString, required = false,
                                 default = nil)
  if valid_589728 != nil:
    section.add "nodePoolId", valid_589728
  var valid_589729 = query.getOrDefault("zone")
  valid_589729 = validateParameter(valid_589729, JString, required = false,
                                 default = nil)
  if valid_589729 != nil:
    section.add "zone", valid_589729
  var valid_589730 = query.getOrDefault("key")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = nil)
  if valid_589730 != nil:
    section.add "key", valid_589730
  var valid_589731 = query.getOrDefault("$.xgafv")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = newJString("1"))
  if valid_589731 != nil:
    section.add "$.xgafv", valid_589731
  var valid_589732 = query.getOrDefault("projectId")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = nil)
  if valid_589732 != nil:
    section.add "projectId", valid_589732
  var valid_589733 = query.getOrDefault("prettyPrint")
  valid_589733 = validateParameter(valid_589733, JBool, required = false,
                                 default = newJBool(true))
  if valid_589733 != nil:
    section.add "prettyPrint", valid_589733
  var valid_589734 = query.getOrDefault("clusterId")
  valid_589734 = validateParameter(valid_589734, JString, required = false,
                                 default = nil)
  if valid_589734 != nil:
    section.add "clusterId", valid_589734
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589735: Call_ContainerProjectsLocationsClustersNodePoolsDelete_589716;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_589735.validator(path, query, header, formData, body)
  let scheme = call_589735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589735.url(scheme.get, call_589735.host, call_589735.base,
                         call_589735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589735, url, valid)

proc call*(call_589736: Call_ContainerProjectsLocationsClustersNodePoolsDelete_589716;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          nodePoolId: string = ""; zone: string = ""; key: string = ""; Xgafv: string = "1";
          projectId: string = ""; prettyPrint: bool = true; clusterId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   nodePoolId: string
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  var path_589737 = newJObject()
  var query_589738 = newJObject()
  add(query_589738, "upload_protocol", newJString(uploadProtocol))
  add(query_589738, "fields", newJString(fields))
  add(query_589738, "quotaUser", newJString(quotaUser))
  add(path_589737, "name", newJString(name))
  add(query_589738, "alt", newJString(alt))
  add(query_589738, "oauth_token", newJString(oauthToken))
  add(query_589738, "callback", newJString(callback))
  add(query_589738, "access_token", newJString(accessToken))
  add(query_589738, "uploadType", newJString(uploadType))
  add(query_589738, "nodePoolId", newJString(nodePoolId))
  add(query_589738, "zone", newJString(zone))
  add(query_589738, "key", newJString(key))
  add(query_589738, "$.xgafv", newJString(Xgafv))
  add(query_589738, "projectId", newJString(projectId))
  add(query_589738, "prettyPrint", newJBool(prettyPrint))
  add(query_589738, "clusterId", newJString(clusterId))
  result = call_589736.call(path_589737, query_589738, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsDelete* = Call_ContainerProjectsLocationsClustersNodePoolsDelete_589716(
    name: "containerProjectsLocationsClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsDelete_589717,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsDelete_589718,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsGetServerConfig_589739 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsGetServerConfig_589741(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/serverConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsGetServerConfig_589740(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589742 = path.getOrDefault("name")
  valid_589742 = validateParameter(valid_589742, JString, required = true,
                                 default = nil)
  if valid_589742 != nil:
    section.add "name", valid_589742
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589743 = query.getOrDefault("upload_protocol")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "upload_protocol", valid_589743
  var valid_589744 = query.getOrDefault("fields")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = nil)
  if valid_589744 != nil:
    section.add "fields", valid_589744
  var valid_589745 = query.getOrDefault("quotaUser")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = nil)
  if valid_589745 != nil:
    section.add "quotaUser", valid_589745
  var valid_589746 = query.getOrDefault("alt")
  valid_589746 = validateParameter(valid_589746, JString, required = false,
                                 default = newJString("json"))
  if valid_589746 != nil:
    section.add "alt", valid_589746
  var valid_589747 = query.getOrDefault("oauth_token")
  valid_589747 = validateParameter(valid_589747, JString, required = false,
                                 default = nil)
  if valid_589747 != nil:
    section.add "oauth_token", valid_589747
  var valid_589748 = query.getOrDefault("callback")
  valid_589748 = validateParameter(valid_589748, JString, required = false,
                                 default = nil)
  if valid_589748 != nil:
    section.add "callback", valid_589748
  var valid_589749 = query.getOrDefault("access_token")
  valid_589749 = validateParameter(valid_589749, JString, required = false,
                                 default = nil)
  if valid_589749 != nil:
    section.add "access_token", valid_589749
  var valid_589750 = query.getOrDefault("uploadType")
  valid_589750 = validateParameter(valid_589750, JString, required = false,
                                 default = nil)
  if valid_589750 != nil:
    section.add "uploadType", valid_589750
  var valid_589751 = query.getOrDefault("zone")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = nil)
  if valid_589751 != nil:
    section.add "zone", valid_589751
  var valid_589752 = query.getOrDefault("key")
  valid_589752 = validateParameter(valid_589752, JString, required = false,
                                 default = nil)
  if valid_589752 != nil:
    section.add "key", valid_589752
  var valid_589753 = query.getOrDefault("$.xgafv")
  valid_589753 = validateParameter(valid_589753, JString, required = false,
                                 default = newJString("1"))
  if valid_589753 != nil:
    section.add "$.xgafv", valid_589753
  var valid_589754 = query.getOrDefault("projectId")
  valid_589754 = validateParameter(valid_589754, JString, required = false,
                                 default = nil)
  if valid_589754 != nil:
    section.add "projectId", valid_589754
  var valid_589755 = query.getOrDefault("prettyPrint")
  valid_589755 = validateParameter(valid_589755, JBool, required = false,
                                 default = newJBool(true))
  if valid_589755 != nil:
    section.add "prettyPrint", valid_589755
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589756: Call_ContainerProjectsLocationsGetServerConfig_589739;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_589756.validator(path, query, header, formData, body)
  let scheme = call_589756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589756.url(scheme.get, call_589756.host, call_589756.base,
                         call_589756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589756, url, valid)

proc call*(call_589757: Call_ContainerProjectsLocationsGetServerConfig_589739;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          zone: string = ""; key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsGetServerConfig
  ## Returns configuration info about the Google Kubernetes Engine service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589758 = newJObject()
  var query_589759 = newJObject()
  add(query_589759, "upload_protocol", newJString(uploadProtocol))
  add(query_589759, "fields", newJString(fields))
  add(query_589759, "quotaUser", newJString(quotaUser))
  add(path_589758, "name", newJString(name))
  add(query_589759, "alt", newJString(alt))
  add(query_589759, "oauth_token", newJString(oauthToken))
  add(query_589759, "callback", newJString(callback))
  add(query_589759, "access_token", newJString(accessToken))
  add(query_589759, "uploadType", newJString(uploadType))
  add(query_589759, "zone", newJString(zone))
  add(query_589759, "key", newJString(key))
  add(query_589759, "$.xgafv", newJString(Xgafv))
  add(query_589759, "projectId", newJString(projectId))
  add(query_589759, "prettyPrint", newJBool(prettyPrint))
  result = call_589757.call(path_589758, query_589759, nil, nil, nil)

var containerProjectsLocationsGetServerConfig* = Call_ContainerProjectsLocationsGetServerConfig_589739(
    name: "containerProjectsLocationsGetServerConfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{name}/serverConfig",
    validator: validate_ContainerProjectsLocationsGetServerConfig_589740,
    base: "/", url: url_ContainerProjectsLocationsGetServerConfig_589741,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsCancel_589760 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsOperationsCancel_589762(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsCancel_589761(path: JsonNode;
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
  var valid_589763 = path.getOrDefault("name")
  valid_589763 = validateParameter(valid_589763, JString, required = true,
                                 default = nil)
  if valid_589763 != nil:
    section.add "name", valid_589763
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
  section = newJObject()
  var valid_589764 = query.getOrDefault("upload_protocol")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = nil)
  if valid_589764 != nil:
    section.add "upload_protocol", valid_589764
  var valid_589765 = query.getOrDefault("fields")
  valid_589765 = validateParameter(valid_589765, JString, required = false,
                                 default = nil)
  if valid_589765 != nil:
    section.add "fields", valid_589765
  var valid_589766 = query.getOrDefault("quotaUser")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = nil)
  if valid_589766 != nil:
    section.add "quotaUser", valid_589766
  var valid_589767 = query.getOrDefault("alt")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = newJString("json"))
  if valid_589767 != nil:
    section.add "alt", valid_589767
  var valid_589768 = query.getOrDefault("oauth_token")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "oauth_token", valid_589768
  var valid_589769 = query.getOrDefault("callback")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = nil)
  if valid_589769 != nil:
    section.add "callback", valid_589769
  var valid_589770 = query.getOrDefault("access_token")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "access_token", valid_589770
  var valid_589771 = query.getOrDefault("uploadType")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "uploadType", valid_589771
  var valid_589772 = query.getOrDefault("key")
  valid_589772 = validateParameter(valid_589772, JString, required = false,
                                 default = nil)
  if valid_589772 != nil:
    section.add "key", valid_589772
  var valid_589773 = query.getOrDefault("$.xgafv")
  valid_589773 = validateParameter(valid_589773, JString, required = false,
                                 default = newJString("1"))
  if valid_589773 != nil:
    section.add "$.xgafv", valid_589773
  var valid_589774 = query.getOrDefault("prettyPrint")
  valid_589774 = validateParameter(valid_589774, JBool, required = false,
                                 default = newJBool(true))
  if valid_589774 != nil:
    section.add "prettyPrint", valid_589774
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

proc call*(call_589776: Call_ContainerProjectsLocationsOperationsCancel_589760;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_589776.validator(path, query, header, formData, body)
  let scheme = call_589776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589776.url(scheme.get, call_589776.host, call_589776.base,
                         call_589776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589776, url, valid)

proc call*(call_589777: Call_ContainerProjectsLocationsOperationsCancel_589760;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_589778 = newJObject()
  var query_589779 = newJObject()
  var body_589780 = newJObject()
  add(query_589779, "upload_protocol", newJString(uploadProtocol))
  add(query_589779, "fields", newJString(fields))
  add(query_589779, "quotaUser", newJString(quotaUser))
  add(path_589778, "name", newJString(name))
  add(query_589779, "alt", newJString(alt))
  add(query_589779, "oauth_token", newJString(oauthToken))
  add(query_589779, "callback", newJString(callback))
  add(query_589779, "access_token", newJString(accessToken))
  add(query_589779, "uploadType", newJString(uploadType))
  add(query_589779, "key", newJString(key))
  add(query_589779, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589780 = body
  add(query_589779, "prettyPrint", newJBool(prettyPrint))
  result = call_589777.call(path_589778, query_589779, nil, nil, body_589780)

var containerProjectsLocationsOperationsCancel* = Call_ContainerProjectsLocationsOperationsCancel_589760(
    name: "containerProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ContainerProjectsLocationsOperationsCancel_589761,
    base: "/", url: url_ContainerProjectsLocationsOperationsCancel_589762,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCompleteIpRotation_589781 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersCompleteIpRotation_589783(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":completeIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCompleteIpRotation_589782(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589784 = path.getOrDefault("name")
  valid_589784 = validateParameter(valid_589784, JString, required = true,
                                 default = nil)
  if valid_589784 != nil:
    section.add "name", valid_589784
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
  section = newJObject()
  var valid_589785 = query.getOrDefault("upload_protocol")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "upload_protocol", valid_589785
  var valid_589786 = query.getOrDefault("fields")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = nil)
  if valid_589786 != nil:
    section.add "fields", valid_589786
  var valid_589787 = query.getOrDefault("quotaUser")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = nil)
  if valid_589787 != nil:
    section.add "quotaUser", valid_589787
  var valid_589788 = query.getOrDefault("alt")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = newJString("json"))
  if valid_589788 != nil:
    section.add "alt", valid_589788
  var valid_589789 = query.getOrDefault("oauth_token")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "oauth_token", valid_589789
  var valid_589790 = query.getOrDefault("callback")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "callback", valid_589790
  var valid_589791 = query.getOrDefault("access_token")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = nil)
  if valid_589791 != nil:
    section.add "access_token", valid_589791
  var valid_589792 = query.getOrDefault("uploadType")
  valid_589792 = validateParameter(valid_589792, JString, required = false,
                                 default = nil)
  if valid_589792 != nil:
    section.add "uploadType", valid_589792
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
  var valid_589795 = query.getOrDefault("prettyPrint")
  valid_589795 = validateParameter(valid_589795, JBool, required = false,
                                 default = newJBool(true))
  if valid_589795 != nil:
    section.add "prettyPrint", valid_589795
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

proc call*(call_589797: Call_ContainerProjectsLocationsClustersCompleteIpRotation_589781;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_589797.validator(path, query, header, formData, body)
  let scheme = call_589797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589797.url(scheme.get, call_589797.host, call_589797.base,
                         call_589797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589797, url, valid)

proc call*(call_589798: Call_ContainerProjectsLocationsClustersCompleteIpRotation_589781;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_589799 = newJObject()
  var query_589800 = newJObject()
  var body_589801 = newJObject()
  add(query_589800, "upload_protocol", newJString(uploadProtocol))
  add(query_589800, "fields", newJString(fields))
  add(query_589800, "quotaUser", newJString(quotaUser))
  add(path_589799, "name", newJString(name))
  add(query_589800, "alt", newJString(alt))
  add(query_589800, "oauth_token", newJString(oauthToken))
  add(query_589800, "callback", newJString(callback))
  add(query_589800, "access_token", newJString(accessToken))
  add(query_589800, "uploadType", newJString(uploadType))
  add(query_589800, "key", newJString(key))
  add(query_589800, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589801 = body
  add(query_589800, "prettyPrint", newJBool(prettyPrint))
  result = call_589798.call(path_589799, query_589800, nil, nil, body_589801)

var containerProjectsLocationsClustersCompleteIpRotation* = Call_ContainerProjectsLocationsClustersCompleteIpRotation_589781(
    name: "containerProjectsLocationsClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:completeIpRotation",
    validator: validate_ContainerProjectsLocationsClustersCompleteIpRotation_589782,
    base: "/", url: url_ContainerProjectsLocationsClustersCompleteIpRotation_589783,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsRollback_589802 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsRollback_589804(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsRollback_589803(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
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
  var valid_589810 = query.getOrDefault("oauth_token")
  valid_589810 = validateParameter(valid_589810, JString, required = false,
                                 default = nil)
  if valid_589810 != nil:
    section.add "oauth_token", valid_589810
  var valid_589811 = query.getOrDefault("callback")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "callback", valid_589811
  var valid_589812 = query.getOrDefault("access_token")
  valid_589812 = validateParameter(valid_589812, JString, required = false,
                                 default = nil)
  if valid_589812 != nil:
    section.add "access_token", valid_589812
  var valid_589813 = query.getOrDefault("uploadType")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = nil)
  if valid_589813 != nil:
    section.add "uploadType", valid_589813
  var valid_589814 = query.getOrDefault("key")
  valid_589814 = validateParameter(valid_589814, JString, required = false,
                                 default = nil)
  if valid_589814 != nil:
    section.add "key", valid_589814
  var valid_589815 = query.getOrDefault("$.xgafv")
  valid_589815 = validateParameter(valid_589815, JString, required = false,
                                 default = newJString("1"))
  if valid_589815 != nil:
    section.add "$.xgafv", valid_589815
  var valid_589816 = query.getOrDefault("prettyPrint")
  valid_589816 = validateParameter(valid_589816, JBool, required = false,
                                 default = newJBool(true))
  if valid_589816 != nil:
    section.add "prettyPrint", valid_589816
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

proc call*(call_589818: Call_ContainerProjectsLocationsClustersNodePoolsRollback_589802;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_589818.validator(path, query, header, formData, body)
  let scheme = call_589818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589818.url(scheme.get, call_589818.host, call_589818.base,
                         call_589818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589818, url, valid)

proc call*(call_589819: Call_ContainerProjectsLocationsClustersNodePoolsRollback_589802;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersNodePoolsRollback
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
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
  var path_589820 = newJObject()
  var query_589821 = newJObject()
  var body_589822 = newJObject()
  add(query_589821, "upload_protocol", newJString(uploadProtocol))
  add(query_589821, "fields", newJString(fields))
  add(query_589821, "quotaUser", newJString(quotaUser))
  add(path_589820, "name", newJString(name))
  add(query_589821, "alt", newJString(alt))
  add(query_589821, "oauth_token", newJString(oauthToken))
  add(query_589821, "callback", newJString(callback))
  add(query_589821, "access_token", newJString(accessToken))
  add(query_589821, "uploadType", newJString(uploadType))
  add(query_589821, "key", newJString(key))
  add(query_589821, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589822 = body
  add(query_589821, "prettyPrint", newJBool(prettyPrint))
  result = call_589819.call(path_589820, query_589821, nil, nil, body_589822)

var containerProjectsLocationsClustersNodePoolsRollback* = Call_ContainerProjectsLocationsClustersNodePoolsRollback_589802(
    name: "containerProjectsLocationsClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:rollback",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsRollback_589803,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsRollback_589804,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetAddons_589823 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetAddons_589825(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setAddons")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetAddons_589824(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set addons.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589826 = path.getOrDefault("name")
  valid_589826 = validateParameter(valid_589826, JString, required = true,
                                 default = nil)
  if valid_589826 != nil:
    section.add "name", valid_589826
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
  section = newJObject()
  var valid_589827 = query.getOrDefault("upload_protocol")
  valid_589827 = validateParameter(valid_589827, JString, required = false,
                                 default = nil)
  if valid_589827 != nil:
    section.add "upload_protocol", valid_589827
  var valid_589828 = query.getOrDefault("fields")
  valid_589828 = validateParameter(valid_589828, JString, required = false,
                                 default = nil)
  if valid_589828 != nil:
    section.add "fields", valid_589828
  var valid_589829 = query.getOrDefault("quotaUser")
  valid_589829 = validateParameter(valid_589829, JString, required = false,
                                 default = nil)
  if valid_589829 != nil:
    section.add "quotaUser", valid_589829
  var valid_589830 = query.getOrDefault("alt")
  valid_589830 = validateParameter(valid_589830, JString, required = false,
                                 default = newJString("json"))
  if valid_589830 != nil:
    section.add "alt", valid_589830
  var valid_589831 = query.getOrDefault("oauth_token")
  valid_589831 = validateParameter(valid_589831, JString, required = false,
                                 default = nil)
  if valid_589831 != nil:
    section.add "oauth_token", valid_589831
  var valid_589832 = query.getOrDefault("callback")
  valid_589832 = validateParameter(valid_589832, JString, required = false,
                                 default = nil)
  if valid_589832 != nil:
    section.add "callback", valid_589832
  var valid_589833 = query.getOrDefault("access_token")
  valid_589833 = validateParameter(valid_589833, JString, required = false,
                                 default = nil)
  if valid_589833 != nil:
    section.add "access_token", valid_589833
  var valid_589834 = query.getOrDefault("uploadType")
  valid_589834 = validateParameter(valid_589834, JString, required = false,
                                 default = nil)
  if valid_589834 != nil:
    section.add "uploadType", valid_589834
  var valid_589835 = query.getOrDefault("key")
  valid_589835 = validateParameter(valid_589835, JString, required = false,
                                 default = nil)
  if valid_589835 != nil:
    section.add "key", valid_589835
  var valid_589836 = query.getOrDefault("$.xgafv")
  valid_589836 = validateParameter(valid_589836, JString, required = false,
                                 default = newJString("1"))
  if valid_589836 != nil:
    section.add "$.xgafv", valid_589836
  var valid_589837 = query.getOrDefault("prettyPrint")
  valid_589837 = validateParameter(valid_589837, JBool, required = false,
                                 default = newJBool(true))
  if valid_589837 != nil:
    section.add "prettyPrint", valid_589837
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

proc call*(call_589839: Call_ContainerProjectsLocationsClustersSetAddons_589823;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_589839.validator(path, query, header, formData, body)
  let scheme = call_589839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589839.url(scheme.get, call_589839.host, call_589839.base,
                         call_589839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589839, url, valid)

proc call*(call_589840: Call_ContainerProjectsLocationsClustersSetAddons_589823;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetAddons
  ## Sets the addons for a specific cluster.
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
  var path_589841 = newJObject()
  var query_589842 = newJObject()
  var body_589843 = newJObject()
  add(query_589842, "upload_protocol", newJString(uploadProtocol))
  add(query_589842, "fields", newJString(fields))
  add(query_589842, "quotaUser", newJString(quotaUser))
  add(path_589841, "name", newJString(name))
  add(query_589842, "alt", newJString(alt))
  add(query_589842, "oauth_token", newJString(oauthToken))
  add(query_589842, "callback", newJString(callback))
  add(query_589842, "access_token", newJString(accessToken))
  add(query_589842, "uploadType", newJString(uploadType))
  add(query_589842, "key", newJString(key))
  add(query_589842, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589843 = body
  add(query_589842, "prettyPrint", newJBool(prettyPrint))
  result = call_589840.call(path_589841, query_589842, nil, nil, body_589843)

var containerProjectsLocationsClustersSetAddons* = Call_ContainerProjectsLocationsClustersSetAddons_589823(
    name: "containerProjectsLocationsClustersSetAddons",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAddons",
    validator: validate_ContainerProjectsLocationsClustersSetAddons_589824,
    base: "/", url: url_ContainerProjectsLocationsClustersSetAddons_589825,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589844 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589846(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setAutoscaling")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589845(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings for the specified node pool.
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
  var valid_589847 = path.getOrDefault("name")
  valid_589847 = validateParameter(valid_589847, JString, required = true,
                                 default = nil)
  if valid_589847 != nil:
    section.add "name", valid_589847
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
  section = newJObject()
  var valid_589848 = query.getOrDefault("upload_protocol")
  valid_589848 = validateParameter(valid_589848, JString, required = false,
                                 default = nil)
  if valid_589848 != nil:
    section.add "upload_protocol", valid_589848
  var valid_589849 = query.getOrDefault("fields")
  valid_589849 = validateParameter(valid_589849, JString, required = false,
                                 default = nil)
  if valid_589849 != nil:
    section.add "fields", valid_589849
  var valid_589850 = query.getOrDefault("quotaUser")
  valid_589850 = validateParameter(valid_589850, JString, required = false,
                                 default = nil)
  if valid_589850 != nil:
    section.add "quotaUser", valid_589850
  var valid_589851 = query.getOrDefault("alt")
  valid_589851 = validateParameter(valid_589851, JString, required = false,
                                 default = newJString("json"))
  if valid_589851 != nil:
    section.add "alt", valid_589851
  var valid_589852 = query.getOrDefault("oauth_token")
  valid_589852 = validateParameter(valid_589852, JString, required = false,
                                 default = nil)
  if valid_589852 != nil:
    section.add "oauth_token", valid_589852
  var valid_589853 = query.getOrDefault("callback")
  valid_589853 = validateParameter(valid_589853, JString, required = false,
                                 default = nil)
  if valid_589853 != nil:
    section.add "callback", valid_589853
  var valid_589854 = query.getOrDefault("access_token")
  valid_589854 = validateParameter(valid_589854, JString, required = false,
                                 default = nil)
  if valid_589854 != nil:
    section.add "access_token", valid_589854
  var valid_589855 = query.getOrDefault("uploadType")
  valid_589855 = validateParameter(valid_589855, JString, required = false,
                                 default = nil)
  if valid_589855 != nil:
    section.add "uploadType", valid_589855
  var valid_589856 = query.getOrDefault("key")
  valid_589856 = validateParameter(valid_589856, JString, required = false,
                                 default = nil)
  if valid_589856 != nil:
    section.add "key", valid_589856
  var valid_589857 = query.getOrDefault("$.xgafv")
  valid_589857 = validateParameter(valid_589857, JString, required = false,
                                 default = newJString("1"))
  if valid_589857 != nil:
    section.add "$.xgafv", valid_589857
  var valid_589858 = query.getOrDefault("prettyPrint")
  valid_589858 = validateParameter(valid_589858, JBool, required = false,
                                 default = newJBool(true))
  if valid_589858 != nil:
    section.add "prettyPrint", valid_589858
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

proc call*(call_589860: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589844;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_589860.validator(path, query, header, formData, body)
  let scheme = call_589860.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589860.url(scheme.get, call_589860.host, call_589860.base,
                         call_589860.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589860, url, valid)

proc call*(call_589861: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589844;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetAutoscaling
  ## Sets the autoscaling settings for the specified node pool.
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
  var path_589862 = newJObject()
  var query_589863 = newJObject()
  var body_589864 = newJObject()
  add(query_589863, "upload_protocol", newJString(uploadProtocol))
  add(query_589863, "fields", newJString(fields))
  add(query_589863, "quotaUser", newJString(quotaUser))
  add(path_589862, "name", newJString(name))
  add(query_589863, "alt", newJString(alt))
  add(query_589863, "oauth_token", newJString(oauthToken))
  add(query_589863, "callback", newJString(callback))
  add(query_589863, "access_token", newJString(accessToken))
  add(query_589863, "uploadType", newJString(uploadType))
  add(query_589863, "key", newJString(key))
  add(query_589863, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589864 = body
  add(query_589863, "prettyPrint", newJBool(prettyPrint))
  result = call_589861.call(path_589862, query_589863, nil, nil, body_589864)

var containerProjectsLocationsClustersNodePoolsSetAutoscaling* = Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589844(
    name: "containerProjectsLocationsClustersNodePoolsSetAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAutoscaling", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589845,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_589846,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLegacyAbac_589865 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetLegacyAbac_589867(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLegacyAbac")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLegacyAbac_589866(
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
  var valid_589868 = path.getOrDefault("name")
  valid_589868 = validateParameter(valid_589868, JString, required = true,
                                 default = nil)
  if valid_589868 != nil:
    section.add "name", valid_589868
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
  section = newJObject()
  var valid_589869 = query.getOrDefault("upload_protocol")
  valid_589869 = validateParameter(valid_589869, JString, required = false,
                                 default = nil)
  if valid_589869 != nil:
    section.add "upload_protocol", valid_589869
  var valid_589870 = query.getOrDefault("fields")
  valid_589870 = validateParameter(valid_589870, JString, required = false,
                                 default = nil)
  if valid_589870 != nil:
    section.add "fields", valid_589870
  var valid_589871 = query.getOrDefault("quotaUser")
  valid_589871 = validateParameter(valid_589871, JString, required = false,
                                 default = nil)
  if valid_589871 != nil:
    section.add "quotaUser", valid_589871
  var valid_589872 = query.getOrDefault("alt")
  valid_589872 = validateParameter(valid_589872, JString, required = false,
                                 default = newJString("json"))
  if valid_589872 != nil:
    section.add "alt", valid_589872
  var valid_589873 = query.getOrDefault("oauth_token")
  valid_589873 = validateParameter(valid_589873, JString, required = false,
                                 default = nil)
  if valid_589873 != nil:
    section.add "oauth_token", valid_589873
  var valid_589874 = query.getOrDefault("callback")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "callback", valid_589874
  var valid_589875 = query.getOrDefault("access_token")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = nil)
  if valid_589875 != nil:
    section.add "access_token", valid_589875
  var valid_589876 = query.getOrDefault("uploadType")
  valid_589876 = validateParameter(valid_589876, JString, required = false,
                                 default = nil)
  if valid_589876 != nil:
    section.add "uploadType", valid_589876
  var valid_589877 = query.getOrDefault("key")
  valid_589877 = validateParameter(valid_589877, JString, required = false,
                                 default = nil)
  if valid_589877 != nil:
    section.add "key", valid_589877
  var valid_589878 = query.getOrDefault("$.xgafv")
  valid_589878 = validateParameter(valid_589878, JString, required = false,
                                 default = newJString("1"))
  if valid_589878 != nil:
    section.add "$.xgafv", valid_589878
  var valid_589879 = query.getOrDefault("prettyPrint")
  valid_589879 = validateParameter(valid_589879, JBool, required = false,
                                 default = newJBool(true))
  if valid_589879 != nil:
    section.add "prettyPrint", valid_589879
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

proc call*(call_589881: Call_ContainerProjectsLocationsClustersSetLegacyAbac_589865;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_589881.validator(path, query, header, formData, body)
  let scheme = call_589881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589881.url(scheme.get, call_589881.host, call_589881.base,
                         call_589881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589881, url, valid)

proc call*(call_589882: Call_ContainerProjectsLocationsClustersSetLegacyAbac_589865;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_589883 = newJObject()
  var query_589884 = newJObject()
  var body_589885 = newJObject()
  add(query_589884, "upload_protocol", newJString(uploadProtocol))
  add(query_589884, "fields", newJString(fields))
  add(query_589884, "quotaUser", newJString(quotaUser))
  add(path_589883, "name", newJString(name))
  add(query_589884, "alt", newJString(alt))
  add(query_589884, "oauth_token", newJString(oauthToken))
  add(query_589884, "callback", newJString(callback))
  add(query_589884, "access_token", newJString(accessToken))
  add(query_589884, "uploadType", newJString(uploadType))
  add(query_589884, "key", newJString(key))
  add(query_589884, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589885 = body
  add(query_589884, "prettyPrint", newJBool(prettyPrint))
  result = call_589882.call(path_589883, query_589884, nil, nil, body_589885)

var containerProjectsLocationsClustersSetLegacyAbac* = Call_ContainerProjectsLocationsClustersSetLegacyAbac_589865(
    name: "containerProjectsLocationsClustersSetLegacyAbac",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLegacyAbac",
    validator: validate_ContainerProjectsLocationsClustersSetLegacyAbac_589866,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLegacyAbac_589867,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLocations_589886 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetLocations_589888(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLocations_589887(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the locations for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set locations.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589889 = path.getOrDefault("name")
  valid_589889 = validateParameter(valid_589889, JString, required = true,
                                 default = nil)
  if valid_589889 != nil:
    section.add "name", valid_589889
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
  section = newJObject()
  var valid_589890 = query.getOrDefault("upload_protocol")
  valid_589890 = validateParameter(valid_589890, JString, required = false,
                                 default = nil)
  if valid_589890 != nil:
    section.add "upload_protocol", valid_589890
  var valid_589891 = query.getOrDefault("fields")
  valid_589891 = validateParameter(valid_589891, JString, required = false,
                                 default = nil)
  if valid_589891 != nil:
    section.add "fields", valid_589891
  var valid_589892 = query.getOrDefault("quotaUser")
  valid_589892 = validateParameter(valid_589892, JString, required = false,
                                 default = nil)
  if valid_589892 != nil:
    section.add "quotaUser", valid_589892
  var valid_589893 = query.getOrDefault("alt")
  valid_589893 = validateParameter(valid_589893, JString, required = false,
                                 default = newJString("json"))
  if valid_589893 != nil:
    section.add "alt", valid_589893
  var valid_589894 = query.getOrDefault("oauth_token")
  valid_589894 = validateParameter(valid_589894, JString, required = false,
                                 default = nil)
  if valid_589894 != nil:
    section.add "oauth_token", valid_589894
  var valid_589895 = query.getOrDefault("callback")
  valid_589895 = validateParameter(valid_589895, JString, required = false,
                                 default = nil)
  if valid_589895 != nil:
    section.add "callback", valid_589895
  var valid_589896 = query.getOrDefault("access_token")
  valid_589896 = validateParameter(valid_589896, JString, required = false,
                                 default = nil)
  if valid_589896 != nil:
    section.add "access_token", valid_589896
  var valid_589897 = query.getOrDefault("uploadType")
  valid_589897 = validateParameter(valid_589897, JString, required = false,
                                 default = nil)
  if valid_589897 != nil:
    section.add "uploadType", valid_589897
  var valid_589898 = query.getOrDefault("key")
  valid_589898 = validateParameter(valid_589898, JString, required = false,
                                 default = nil)
  if valid_589898 != nil:
    section.add "key", valid_589898
  var valid_589899 = query.getOrDefault("$.xgafv")
  valid_589899 = validateParameter(valid_589899, JString, required = false,
                                 default = newJString("1"))
  if valid_589899 != nil:
    section.add "$.xgafv", valid_589899
  var valid_589900 = query.getOrDefault("prettyPrint")
  valid_589900 = validateParameter(valid_589900, JBool, required = false,
                                 default = newJBool(true))
  if valid_589900 != nil:
    section.add "prettyPrint", valid_589900
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

proc call*(call_589902: Call_ContainerProjectsLocationsClustersSetLocations_589886;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_589902.validator(path, query, header, formData, body)
  let scheme = call_589902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589902.url(scheme.get, call_589902.host, call_589902.base,
                         call_589902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589902, url, valid)

proc call*(call_589903: Call_ContainerProjectsLocationsClustersSetLocations_589886;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetLocations
  ## Sets the locations for a specific cluster.
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
  var path_589904 = newJObject()
  var query_589905 = newJObject()
  var body_589906 = newJObject()
  add(query_589905, "upload_protocol", newJString(uploadProtocol))
  add(query_589905, "fields", newJString(fields))
  add(query_589905, "quotaUser", newJString(quotaUser))
  add(path_589904, "name", newJString(name))
  add(query_589905, "alt", newJString(alt))
  add(query_589905, "oauth_token", newJString(oauthToken))
  add(query_589905, "callback", newJString(callback))
  add(query_589905, "access_token", newJString(accessToken))
  add(query_589905, "uploadType", newJString(uploadType))
  add(query_589905, "key", newJString(key))
  add(query_589905, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589906 = body
  add(query_589905, "prettyPrint", newJBool(prettyPrint))
  result = call_589903.call(path_589904, query_589905, nil, nil, body_589906)

var containerProjectsLocationsClustersSetLocations* = Call_ContainerProjectsLocationsClustersSetLocations_589886(
    name: "containerProjectsLocationsClustersSetLocations",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLocations",
    validator: validate_ContainerProjectsLocationsClustersSetLocations_589887,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLocations_589888,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLogging_589907 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetLogging_589909(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setLogging")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLogging_589908(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set logging.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589910 = path.getOrDefault("name")
  valid_589910 = validateParameter(valid_589910, JString, required = true,
                                 default = nil)
  if valid_589910 != nil:
    section.add "name", valid_589910
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
  section = newJObject()
  var valid_589911 = query.getOrDefault("upload_protocol")
  valid_589911 = validateParameter(valid_589911, JString, required = false,
                                 default = nil)
  if valid_589911 != nil:
    section.add "upload_protocol", valid_589911
  var valid_589912 = query.getOrDefault("fields")
  valid_589912 = validateParameter(valid_589912, JString, required = false,
                                 default = nil)
  if valid_589912 != nil:
    section.add "fields", valid_589912
  var valid_589913 = query.getOrDefault("quotaUser")
  valid_589913 = validateParameter(valid_589913, JString, required = false,
                                 default = nil)
  if valid_589913 != nil:
    section.add "quotaUser", valid_589913
  var valid_589914 = query.getOrDefault("alt")
  valid_589914 = validateParameter(valid_589914, JString, required = false,
                                 default = newJString("json"))
  if valid_589914 != nil:
    section.add "alt", valid_589914
  var valid_589915 = query.getOrDefault("oauth_token")
  valid_589915 = validateParameter(valid_589915, JString, required = false,
                                 default = nil)
  if valid_589915 != nil:
    section.add "oauth_token", valid_589915
  var valid_589916 = query.getOrDefault("callback")
  valid_589916 = validateParameter(valid_589916, JString, required = false,
                                 default = nil)
  if valid_589916 != nil:
    section.add "callback", valid_589916
  var valid_589917 = query.getOrDefault("access_token")
  valid_589917 = validateParameter(valid_589917, JString, required = false,
                                 default = nil)
  if valid_589917 != nil:
    section.add "access_token", valid_589917
  var valid_589918 = query.getOrDefault("uploadType")
  valid_589918 = validateParameter(valid_589918, JString, required = false,
                                 default = nil)
  if valid_589918 != nil:
    section.add "uploadType", valid_589918
  var valid_589919 = query.getOrDefault("key")
  valid_589919 = validateParameter(valid_589919, JString, required = false,
                                 default = nil)
  if valid_589919 != nil:
    section.add "key", valid_589919
  var valid_589920 = query.getOrDefault("$.xgafv")
  valid_589920 = validateParameter(valid_589920, JString, required = false,
                                 default = newJString("1"))
  if valid_589920 != nil:
    section.add "$.xgafv", valid_589920
  var valid_589921 = query.getOrDefault("prettyPrint")
  valid_589921 = validateParameter(valid_589921, JBool, required = false,
                                 default = newJBool(true))
  if valid_589921 != nil:
    section.add "prettyPrint", valid_589921
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

proc call*(call_589923: Call_ContainerProjectsLocationsClustersSetLogging_589907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_589923.validator(path, query, header, formData, body)
  let scheme = call_589923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589923.url(scheme.get, call_589923.host, call_589923.base,
                         call_589923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589923, url, valid)

proc call*(call_589924: Call_ContainerProjectsLocationsClustersSetLogging_589907;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetLogging
  ## Sets the logging service for a specific cluster.
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
  var path_589925 = newJObject()
  var query_589926 = newJObject()
  var body_589927 = newJObject()
  add(query_589926, "upload_protocol", newJString(uploadProtocol))
  add(query_589926, "fields", newJString(fields))
  add(query_589926, "quotaUser", newJString(quotaUser))
  add(path_589925, "name", newJString(name))
  add(query_589926, "alt", newJString(alt))
  add(query_589926, "oauth_token", newJString(oauthToken))
  add(query_589926, "callback", newJString(callback))
  add(query_589926, "access_token", newJString(accessToken))
  add(query_589926, "uploadType", newJString(uploadType))
  add(query_589926, "key", newJString(key))
  add(query_589926, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589927 = body
  add(query_589926, "prettyPrint", newJBool(prettyPrint))
  result = call_589924.call(path_589925, query_589926, nil, nil, body_589927)

var containerProjectsLocationsClustersSetLogging* = Call_ContainerProjectsLocationsClustersSetLogging_589907(
    name: "containerProjectsLocationsClustersSetLogging",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLogging",
    validator: validate_ContainerProjectsLocationsClustersSetLogging_589908,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLogging_589909,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_589928 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetMaintenancePolicy_589930(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMaintenancePolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_589929(
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
  var valid_589931 = path.getOrDefault("name")
  valid_589931 = validateParameter(valid_589931, JString, required = true,
                                 default = nil)
  if valid_589931 != nil:
    section.add "name", valid_589931
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
  section = newJObject()
  var valid_589932 = query.getOrDefault("upload_protocol")
  valid_589932 = validateParameter(valid_589932, JString, required = false,
                                 default = nil)
  if valid_589932 != nil:
    section.add "upload_protocol", valid_589932
  var valid_589933 = query.getOrDefault("fields")
  valid_589933 = validateParameter(valid_589933, JString, required = false,
                                 default = nil)
  if valid_589933 != nil:
    section.add "fields", valid_589933
  var valid_589934 = query.getOrDefault("quotaUser")
  valid_589934 = validateParameter(valid_589934, JString, required = false,
                                 default = nil)
  if valid_589934 != nil:
    section.add "quotaUser", valid_589934
  var valid_589935 = query.getOrDefault("alt")
  valid_589935 = validateParameter(valid_589935, JString, required = false,
                                 default = newJString("json"))
  if valid_589935 != nil:
    section.add "alt", valid_589935
  var valid_589936 = query.getOrDefault("oauth_token")
  valid_589936 = validateParameter(valid_589936, JString, required = false,
                                 default = nil)
  if valid_589936 != nil:
    section.add "oauth_token", valid_589936
  var valid_589937 = query.getOrDefault("callback")
  valid_589937 = validateParameter(valid_589937, JString, required = false,
                                 default = nil)
  if valid_589937 != nil:
    section.add "callback", valid_589937
  var valid_589938 = query.getOrDefault("access_token")
  valid_589938 = validateParameter(valid_589938, JString, required = false,
                                 default = nil)
  if valid_589938 != nil:
    section.add "access_token", valid_589938
  var valid_589939 = query.getOrDefault("uploadType")
  valid_589939 = validateParameter(valid_589939, JString, required = false,
                                 default = nil)
  if valid_589939 != nil:
    section.add "uploadType", valid_589939
  var valid_589940 = query.getOrDefault("key")
  valid_589940 = validateParameter(valid_589940, JString, required = false,
                                 default = nil)
  if valid_589940 != nil:
    section.add "key", valid_589940
  var valid_589941 = query.getOrDefault("$.xgafv")
  valid_589941 = validateParameter(valid_589941, JString, required = false,
                                 default = newJString("1"))
  if valid_589941 != nil:
    section.add "$.xgafv", valid_589941
  var valid_589942 = query.getOrDefault("prettyPrint")
  valid_589942 = validateParameter(valid_589942, JBool, required = false,
                                 default = newJBool(true))
  if valid_589942 != nil:
    section.add "prettyPrint", valid_589942
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

proc call*(call_589944: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_589928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_589944.validator(path, query, header, formData, body)
  let scheme = call_589944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589944.url(scheme.get, call_589944.host, call_589944.base,
                         call_589944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589944, url, valid)

proc call*(call_589945: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_589928;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_589946 = newJObject()
  var query_589947 = newJObject()
  var body_589948 = newJObject()
  add(query_589947, "upload_protocol", newJString(uploadProtocol))
  add(query_589947, "fields", newJString(fields))
  add(query_589947, "quotaUser", newJString(quotaUser))
  add(path_589946, "name", newJString(name))
  add(query_589947, "alt", newJString(alt))
  add(query_589947, "oauth_token", newJString(oauthToken))
  add(query_589947, "callback", newJString(callback))
  add(query_589947, "access_token", newJString(accessToken))
  add(query_589947, "uploadType", newJString(uploadType))
  add(query_589947, "key", newJString(key))
  add(query_589947, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589948 = body
  add(query_589947, "prettyPrint", newJBool(prettyPrint))
  result = call_589945.call(path_589946, query_589947, nil, nil, body_589948)

var containerProjectsLocationsClustersSetMaintenancePolicy* = Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_589928(
    name: "containerProjectsLocationsClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMaintenancePolicy",
    validator: validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_589929,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMaintenancePolicy_589930,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_589949 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsSetManagement_589951(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setManagement")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_589950(
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
  var valid_589952 = path.getOrDefault("name")
  valid_589952 = validateParameter(valid_589952, JString, required = true,
                                 default = nil)
  if valid_589952 != nil:
    section.add "name", valid_589952
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
  section = newJObject()
  var valid_589953 = query.getOrDefault("upload_protocol")
  valid_589953 = validateParameter(valid_589953, JString, required = false,
                                 default = nil)
  if valid_589953 != nil:
    section.add "upload_protocol", valid_589953
  var valid_589954 = query.getOrDefault("fields")
  valid_589954 = validateParameter(valid_589954, JString, required = false,
                                 default = nil)
  if valid_589954 != nil:
    section.add "fields", valid_589954
  var valid_589955 = query.getOrDefault("quotaUser")
  valid_589955 = validateParameter(valid_589955, JString, required = false,
                                 default = nil)
  if valid_589955 != nil:
    section.add "quotaUser", valid_589955
  var valid_589956 = query.getOrDefault("alt")
  valid_589956 = validateParameter(valid_589956, JString, required = false,
                                 default = newJString("json"))
  if valid_589956 != nil:
    section.add "alt", valid_589956
  var valid_589957 = query.getOrDefault("oauth_token")
  valid_589957 = validateParameter(valid_589957, JString, required = false,
                                 default = nil)
  if valid_589957 != nil:
    section.add "oauth_token", valid_589957
  var valid_589958 = query.getOrDefault("callback")
  valid_589958 = validateParameter(valid_589958, JString, required = false,
                                 default = nil)
  if valid_589958 != nil:
    section.add "callback", valid_589958
  var valid_589959 = query.getOrDefault("access_token")
  valid_589959 = validateParameter(valid_589959, JString, required = false,
                                 default = nil)
  if valid_589959 != nil:
    section.add "access_token", valid_589959
  var valid_589960 = query.getOrDefault("uploadType")
  valid_589960 = validateParameter(valid_589960, JString, required = false,
                                 default = nil)
  if valid_589960 != nil:
    section.add "uploadType", valid_589960
  var valid_589961 = query.getOrDefault("key")
  valid_589961 = validateParameter(valid_589961, JString, required = false,
                                 default = nil)
  if valid_589961 != nil:
    section.add "key", valid_589961
  var valid_589962 = query.getOrDefault("$.xgafv")
  valid_589962 = validateParameter(valid_589962, JString, required = false,
                                 default = newJString("1"))
  if valid_589962 != nil:
    section.add "$.xgafv", valid_589962
  var valid_589963 = query.getOrDefault("prettyPrint")
  valid_589963 = validateParameter(valid_589963, JBool, required = false,
                                 default = newJBool(true))
  if valid_589963 != nil:
    section.add "prettyPrint", valid_589963
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

proc call*(call_589965: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_589949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_589965.validator(path, query, header, formData, body)
  let scheme = call_589965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589965.url(scheme.get, call_589965.host, call_589965.base,
                         call_589965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589965, url, valid)

proc call*(call_589966: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_589949;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_589967 = newJObject()
  var query_589968 = newJObject()
  var body_589969 = newJObject()
  add(query_589968, "upload_protocol", newJString(uploadProtocol))
  add(query_589968, "fields", newJString(fields))
  add(query_589968, "quotaUser", newJString(quotaUser))
  add(path_589967, "name", newJString(name))
  add(query_589968, "alt", newJString(alt))
  add(query_589968, "oauth_token", newJString(oauthToken))
  add(query_589968, "callback", newJString(callback))
  add(query_589968, "access_token", newJString(accessToken))
  add(query_589968, "uploadType", newJString(uploadType))
  add(query_589968, "key", newJString(key))
  add(query_589968, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589969 = body
  add(query_589968, "prettyPrint", newJBool(prettyPrint))
  result = call_589966.call(path_589967, query_589968, nil, nil, body_589969)

var containerProjectsLocationsClustersNodePoolsSetManagement* = Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_589949(
    name: "containerProjectsLocationsClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setManagement", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_589950,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetManagement_589951,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMasterAuth_589970 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetMasterAuth_589972(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMasterAuth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMasterAuth_589971(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set auth.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589973 = path.getOrDefault("name")
  valid_589973 = validateParameter(valid_589973, JString, required = true,
                                 default = nil)
  if valid_589973 != nil:
    section.add "name", valid_589973
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
  section = newJObject()
  var valid_589974 = query.getOrDefault("upload_protocol")
  valid_589974 = validateParameter(valid_589974, JString, required = false,
                                 default = nil)
  if valid_589974 != nil:
    section.add "upload_protocol", valid_589974
  var valid_589975 = query.getOrDefault("fields")
  valid_589975 = validateParameter(valid_589975, JString, required = false,
                                 default = nil)
  if valid_589975 != nil:
    section.add "fields", valid_589975
  var valid_589976 = query.getOrDefault("quotaUser")
  valid_589976 = validateParameter(valid_589976, JString, required = false,
                                 default = nil)
  if valid_589976 != nil:
    section.add "quotaUser", valid_589976
  var valid_589977 = query.getOrDefault("alt")
  valid_589977 = validateParameter(valid_589977, JString, required = false,
                                 default = newJString("json"))
  if valid_589977 != nil:
    section.add "alt", valid_589977
  var valid_589978 = query.getOrDefault("oauth_token")
  valid_589978 = validateParameter(valid_589978, JString, required = false,
                                 default = nil)
  if valid_589978 != nil:
    section.add "oauth_token", valid_589978
  var valid_589979 = query.getOrDefault("callback")
  valid_589979 = validateParameter(valid_589979, JString, required = false,
                                 default = nil)
  if valid_589979 != nil:
    section.add "callback", valid_589979
  var valid_589980 = query.getOrDefault("access_token")
  valid_589980 = validateParameter(valid_589980, JString, required = false,
                                 default = nil)
  if valid_589980 != nil:
    section.add "access_token", valid_589980
  var valid_589981 = query.getOrDefault("uploadType")
  valid_589981 = validateParameter(valid_589981, JString, required = false,
                                 default = nil)
  if valid_589981 != nil:
    section.add "uploadType", valid_589981
  var valid_589982 = query.getOrDefault("key")
  valid_589982 = validateParameter(valid_589982, JString, required = false,
                                 default = nil)
  if valid_589982 != nil:
    section.add "key", valid_589982
  var valid_589983 = query.getOrDefault("$.xgafv")
  valid_589983 = validateParameter(valid_589983, JString, required = false,
                                 default = newJString("1"))
  if valid_589983 != nil:
    section.add "$.xgafv", valid_589983
  var valid_589984 = query.getOrDefault("prettyPrint")
  valid_589984 = validateParameter(valid_589984, JBool, required = false,
                                 default = newJBool(true))
  if valid_589984 != nil:
    section.add "prettyPrint", valid_589984
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

proc call*(call_589986: Call_ContainerProjectsLocationsClustersSetMasterAuth_589970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_589986.validator(path, query, header, formData, body)
  let scheme = call_589986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589986.url(scheme.get, call_589986.host, call_589986.base,
                         call_589986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589986, url, valid)

proc call*(call_589987: Call_ContainerProjectsLocationsClustersSetMasterAuth_589970;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetMasterAuth
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
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
  var path_589988 = newJObject()
  var query_589989 = newJObject()
  var body_589990 = newJObject()
  add(query_589989, "upload_protocol", newJString(uploadProtocol))
  add(query_589989, "fields", newJString(fields))
  add(query_589989, "quotaUser", newJString(quotaUser))
  add(path_589988, "name", newJString(name))
  add(query_589989, "alt", newJString(alt))
  add(query_589989, "oauth_token", newJString(oauthToken))
  add(query_589989, "callback", newJString(callback))
  add(query_589989, "access_token", newJString(accessToken))
  add(query_589989, "uploadType", newJString(uploadType))
  add(query_589989, "key", newJString(key))
  add(query_589989, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589990 = body
  add(query_589989, "prettyPrint", newJBool(prettyPrint))
  result = call_589987.call(path_589988, query_589989, nil, nil, body_589990)

var containerProjectsLocationsClustersSetMasterAuth* = Call_ContainerProjectsLocationsClustersSetMasterAuth_589970(
    name: "containerProjectsLocationsClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMasterAuth",
    validator: validate_ContainerProjectsLocationsClustersSetMasterAuth_589971,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMasterAuth_589972,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMonitoring_589991 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetMonitoring_589993(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setMonitoring")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMonitoring_589992(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the monitoring service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to set monitoring.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589994 = path.getOrDefault("name")
  valid_589994 = validateParameter(valid_589994, JString, required = true,
                                 default = nil)
  if valid_589994 != nil:
    section.add "name", valid_589994
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
  section = newJObject()
  var valid_589995 = query.getOrDefault("upload_protocol")
  valid_589995 = validateParameter(valid_589995, JString, required = false,
                                 default = nil)
  if valid_589995 != nil:
    section.add "upload_protocol", valid_589995
  var valid_589996 = query.getOrDefault("fields")
  valid_589996 = validateParameter(valid_589996, JString, required = false,
                                 default = nil)
  if valid_589996 != nil:
    section.add "fields", valid_589996
  var valid_589997 = query.getOrDefault("quotaUser")
  valid_589997 = validateParameter(valid_589997, JString, required = false,
                                 default = nil)
  if valid_589997 != nil:
    section.add "quotaUser", valid_589997
  var valid_589998 = query.getOrDefault("alt")
  valid_589998 = validateParameter(valid_589998, JString, required = false,
                                 default = newJString("json"))
  if valid_589998 != nil:
    section.add "alt", valid_589998
  var valid_589999 = query.getOrDefault("oauth_token")
  valid_589999 = validateParameter(valid_589999, JString, required = false,
                                 default = nil)
  if valid_589999 != nil:
    section.add "oauth_token", valid_589999
  var valid_590000 = query.getOrDefault("callback")
  valid_590000 = validateParameter(valid_590000, JString, required = false,
                                 default = nil)
  if valid_590000 != nil:
    section.add "callback", valid_590000
  var valid_590001 = query.getOrDefault("access_token")
  valid_590001 = validateParameter(valid_590001, JString, required = false,
                                 default = nil)
  if valid_590001 != nil:
    section.add "access_token", valid_590001
  var valid_590002 = query.getOrDefault("uploadType")
  valid_590002 = validateParameter(valid_590002, JString, required = false,
                                 default = nil)
  if valid_590002 != nil:
    section.add "uploadType", valid_590002
  var valid_590003 = query.getOrDefault("key")
  valid_590003 = validateParameter(valid_590003, JString, required = false,
                                 default = nil)
  if valid_590003 != nil:
    section.add "key", valid_590003
  var valid_590004 = query.getOrDefault("$.xgafv")
  valid_590004 = validateParameter(valid_590004, JString, required = false,
                                 default = newJString("1"))
  if valid_590004 != nil:
    section.add "$.xgafv", valid_590004
  var valid_590005 = query.getOrDefault("prettyPrint")
  valid_590005 = validateParameter(valid_590005, JBool, required = false,
                                 default = newJBool(true))
  if valid_590005 != nil:
    section.add "prettyPrint", valid_590005
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

proc call*(call_590007: Call_ContainerProjectsLocationsClustersSetMonitoring_589991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_590007.validator(path, query, header, formData, body)
  let scheme = call_590007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590007.url(scheme.get, call_590007.host, call_590007.base,
                         call_590007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590007, url, valid)

proc call*(call_590008: Call_ContainerProjectsLocationsClustersSetMonitoring_589991;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetMonitoring
  ## Sets the monitoring service for a specific cluster.
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
  var path_590009 = newJObject()
  var query_590010 = newJObject()
  var body_590011 = newJObject()
  add(query_590010, "upload_protocol", newJString(uploadProtocol))
  add(query_590010, "fields", newJString(fields))
  add(query_590010, "quotaUser", newJString(quotaUser))
  add(path_590009, "name", newJString(name))
  add(query_590010, "alt", newJString(alt))
  add(query_590010, "oauth_token", newJString(oauthToken))
  add(query_590010, "callback", newJString(callback))
  add(query_590010, "access_token", newJString(accessToken))
  add(query_590010, "uploadType", newJString(uploadType))
  add(query_590010, "key", newJString(key))
  add(query_590010, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590011 = body
  add(query_590010, "prettyPrint", newJBool(prettyPrint))
  result = call_590008.call(path_590009, query_590010, nil, nil, body_590011)

var containerProjectsLocationsClustersSetMonitoring* = Call_ContainerProjectsLocationsClustersSetMonitoring_589991(
    name: "containerProjectsLocationsClustersSetMonitoring",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMonitoring",
    validator: validate_ContainerProjectsLocationsClustersSetMonitoring_589992,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMonitoring_589993,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetNetworkPolicy_590012 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetNetworkPolicy_590014(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setNetworkPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetNetworkPolicy_590013(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables or disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking
  ## policy. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590015 = path.getOrDefault("name")
  valid_590015 = validateParameter(valid_590015, JString, required = true,
                                 default = nil)
  if valid_590015 != nil:
    section.add "name", valid_590015
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
  section = newJObject()
  var valid_590016 = query.getOrDefault("upload_protocol")
  valid_590016 = validateParameter(valid_590016, JString, required = false,
                                 default = nil)
  if valid_590016 != nil:
    section.add "upload_protocol", valid_590016
  var valid_590017 = query.getOrDefault("fields")
  valid_590017 = validateParameter(valid_590017, JString, required = false,
                                 default = nil)
  if valid_590017 != nil:
    section.add "fields", valid_590017
  var valid_590018 = query.getOrDefault("quotaUser")
  valid_590018 = validateParameter(valid_590018, JString, required = false,
                                 default = nil)
  if valid_590018 != nil:
    section.add "quotaUser", valid_590018
  var valid_590019 = query.getOrDefault("alt")
  valid_590019 = validateParameter(valid_590019, JString, required = false,
                                 default = newJString("json"))
  if valid_590019 != nil:
    section.add "alt", valid_590019
  var valid_590020 = query.getOrDefault("oauth_token")
  valid_590020 = validateParameter(valid_590020, JString, required = false,
                                 default = nil)
  if valid_590020 != nil:
    section.add "oauth_token", valid_590020
  var valid_590021 = query.getOrDefault("callback")
  valid_590021 = validateParameter(valid_590021, JString, required = false,
                                 default = nil)
  if valid_590021 != nil:
    section.add "callback", valid_590021
  var valid_590022 = query.getOrDefault("access_token")
  valid_590022 = validateParameter(valid_590022, JString, required = false,
                                 default = nil)
  if valid_590022 != nil:
    section.add "access_token", valid_590022
  var valid_590023 = query.getOrDefault("uploadType")
  valid_590023 = validateParameter(valid_590023, JString, required = false,
                                 default = nil)
  if valid_590023 != nil:
    section.add "uploadType", valid_590023
  var valid_590024 = query.getOrDefault("key")
  valid_590024 = validateParameter(valid_590024, JString, required = false,
                                 default = nil)
  if valid_590024 != nil:
    section.add "key", valid_590024
  var valid_590025 = query.getOrDefault("$.xgafv")
  valid_590025 = validateParameter(valid_590025, JString, required = false,
                                 default = newJString("1"))
  if valid_590025 != nil:
    section.add "$.xgafv", valid_590025
  var valid_590026 = query.getOrDefault("prettyPrint")
  valid_590026 = validateParameter(valid_590026, JBool, required = false,
                                 default = newJBool(true))
  if valid_590026 != nil:
    section.add "prettyPrint", valid_590026
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

proc call*(call_590028: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_590012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_590028.validator(path, query, header, formData, body)
  let scheme = call_590028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590028.url(scheme.get, call_590028.host, call_590028.base,
                         call_590028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590028, url, valid)

proc call*(call_590029: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_590012;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersSetNetworkPolicy
  ## Enables or disables Network Policy for a cluster.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking
  ## policy. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_590030 = newJObject()
  var query_590031 = newJObject()
  var body_590032 = newJObject()
  add(query_590031, "upload_protocol", newJString(uploadProtocol))
  add(query_590031, "fields", newJString(fields))
  add(query_590031, "quotaUser", newJString(quotaUser))
  add(path_590030, "name", newJString(name))
  add(query_590031, "alt", newJString(alt))
  add(query_590031, "oauth_token", newJString(oauthToken))
  add(query_590031, "callback", newJString(callback))
  add(query_590031, "access_token", newJString(accessToken))
  add(query_590031, "uploadType", newJString(uploadType))
  add(query_590031, "key", newJString(key))
  add(query_590031, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590032 = body
  add(query_590031, "prettyPrint", newJBool(prettyPrint))
  result = call_590029.call(path_590030, query_590031, nil, nil, body_590032)

var containerProjectsLocationsClustersSetNetworkPolicy* = Call_ContainerProjectsLocationsClustersSetNetworkPolicy_590012(
    name: "containerProjectsLocationsClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setNetworkPolicy",
    validator: validate_ContainerProjectsLocationsClustersSetNetworkPolicy_590013,
    base: "/", url: url_ContainerProjectsLocationsClustersSetNetworkPolicy_590014,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetResourceLabels_590033 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersSetResourceLabels_590035(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setResourceLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetResourceLabels_590034(
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
  var valid_590036 = path.getOrDefault("name")
  valid_590036 = validateParameter(valid_590036, JString, required = true,
                                 default = nil)
  if valid_590036 != nil:
    section.add "name", valid_590036
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
  section = newJObject()
  var valid_590037 = query.getOrDefault("upload_protocol")
  valid_590037 = validateParameter(valid_590037, JString, required = false,
                                 default = nil)
  if valid_590037 != nil:
    section.add "upload_protocol", valid_590037
  var valid_590038 = query.getOrDefault("fields")
  valid_590038 = validateParameter(valid_590038, JString, required = false,
                                 default = nil)
  if valid_590038 != nil:
    section.add "fields", valid_590038
  var valid_590039 = query.getOrDefault("quotaUser")
  valid_590039 = validateParameter(valid_590039, JString, required = false,
                                 default = nil)
  if valid_590039 != nil:
    section.add "quotaUser", valid_590039
  var valid_590040 = query.getOrDefault("alt")
  valid_590040 = validateParameter(valid_590040, JString, required = false,
                                 default = newJString("json"))
  if valid_590040 != nil:
    section.add "alt", valid_590040
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

proc call*(call_590049: Call_ContainerProjectsLocationsClustersSetResourceLabels_590033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_590049.validator(path, query, header, formData, body)
  let scheme = call_590049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590049.url(scheme.get, call_590049.host, call_590049.base,
                         call_590049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590049, url, valid)

proc call*(call_590050: Call_ContainerProjectsLocationsClustersSetResourceLabels_590033;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_590051 = newJObject()
  var query_590052 = newJObject()
  var body_590053 = newJObject()
  add(query_590052, "upload_protocol", newJString(uploadProtocol))
  add(query_590052, "fields", newJString(fields))
  add(query_590052, "quotaUser", newJString(quotaUser))
  add(path_590051, "name", newJString(name))
  add(query_590052, "alt", newJString(alt))
  add(query_590052, "oauth_token", newJString(oauthToken))
  add(query_590052, "callback", newJString(callback))
  add(query_590052, "access_token", newJString(accessToken))
  add(query_590052, "uploadType", newJString(uploadType))
  add(query_590052, "key", newJString(key))
  add(query_590052, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590053 = body
  add(query_590052, "prettyPrint", newJBool(prettyPrint))
  result = call_590050.call(path_590051, query_590052, nil, nil, body_590053)

var containerProjectsLocationsClustersSetResourceLabels* = Call_ContainerProjectsLocationsClustersSetResourceLabels_590033(
    name: "containerProjectsLocationsClustersSetResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setResourceLabels",
    validator: validate_ContainerProjectsLocationsClustersSetResourceLabels_590034,
    base: "/", url: url_ContainerProjectsLocationsClustersSetResourceLabels_590035,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetSize_590054 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsSetSize_590056(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setSize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetSize_590055(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the size for a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## size.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590057 = path.getOrDefault("name")
  valid_590057 = validateParameter(valid_590057, JString, required = true,
                                 default = nil)
  if valid_590057 != nil:
    section.add "name", valid_590057
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
  section = newJObject()
  var valid_590058 = query.getOrDefault("upload_protocol")
  valid_590058 = validateParameter(valid_590058, JString, required = false,
                                 default = nil)
  if valid_590058 != nil:
    section.add "upload_protocol", valid_590058
  var valid_590059 = query.getOrDefault("fields")
  valid_590059 = validateParameter(valid_590059, JString, required = false,
                                 default = nil)
  if valid_590059 != nil:
    section.add "fields", valid_590059
  var valid_590060 = query.getOrDefault("quotaUser")
  valid_590060 = validateParameter(valid_590060, JString, required = false,
                                 default = nil)
  if valid_590060 != nil:
    section.add "quotaUser", valid_590060
  var valid_590061 = query.getOrDefault("alt")
  valid_590061 = validateParameter(valid_590061, JString, required = false,
                                 default = newJString("json"))
  if valid_590061 != nil:
    section.add "alt", valid_590061
  var valid_590062 = query.getOrDefault("oauth_token")
  valid_590062 = validateParameter(valid_590062, JString, required = false,
                                 default = nil)
  if valid_590062 != nil:
    section.add "oauth_token", valid_590062
  var valid_590063 = query.getOrDefault("callback")
  valid_590063 = validateParameter(valid_590063, JString, required = false,
                                 default = nil)
  if valid_590063 != nil:
    section.add "callback", valid_590063
  var valid_590064 = query.getOrDefault("access_token")
  valid_590064 = validateParameter(valid_590064, JString, required = false,
                                 default = nil)
  if valid_590064 != nil:
    section.add "access_token", valid_590064
  var valid_590065 = query.getOrDefault("uploadType")
  valid_590065 = validateParameter(valid_590065, JString, required = false,
                                 default = nil)
  if valid_590065 != nil:
    section.add "uploadType", valid_590065
  var valid_590066 = query.getOrDefault("key")
  valid_590066 = validateParameter(valid_590066, JString, required = false,
                                 default = nil)
  if valid_590066 != nil:
    section.add "key", valid_590066
  var valid_590067 = query.getOrDefault("$.xgafv")
  valid_590067 = validateParameter(valid_590067, JString, required = false,
                                 default = newJString("1"))
  if valid_590067 != nil:
    section.add "$.xgafv", valid_590067
  var valid_590068 = query.getOrDefault("prettyPrint")
  valid_590068 = validateParameter(valid_590068, JBool, required = false,
                                 default = newJBool(true))
  if valid_590068 != nil:
    section.add "prettyPrint", valid_590068
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

proc call*(call_590070: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_590054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_590070.validator(path, query, header, formData, body)
  let scheme = call_590070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590070.url(scheme.get, call_590070.host, call_590070.base,
                         call_590070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590070, url, valid)

proc call*(call_590071: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_590054;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetSize
  ## Sets the size for a specific node pool.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## size.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_590072 = newJObject()
  var query_590073 = newJObject()
  var body_590074 = newJObject()
  add(query_590073, "upload_protocol", newJString(uploadProtocol))
  add(query_590073, "fields", newJString(fields))
  add(query_590073, "quotaUser", newJString(quotaUser))
  add(path_590072, "name", newJString(name))
  add(query_590073, "alt", newJString(alt))
  add(query_590073, "oauth_token", newJString(oauthToken))
  add(query_590073, "callback", newJString(callback))
  add(query_590073, "access_token", newJString(accessToken))
  add(query_590073, "uploadType", newJString(uploadType))
  add(query_590073, "key", newJString(key))
  add(query_590073, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590074 = body
  add(query_590073, "prettyPrint", newJBool(prettyPrint))
  result = call_590071.call(path_590072, query_590073, nil, nil, body_590074)

var containerProjectsLocationsClustersNodePoolsSetSize* = Call_ContainerProjectsLocationsClustersNodePoolsSetSize_590054(
    name: "containerProjectsLocationsClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setSize",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsSetSize_590055,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetSize_590056,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersStartIpRotation_590075 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersStartIpRotation_590077(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":startIpRotation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersStartIpRotation_590076(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590078 = path.getOrDefault("name")
  valid_590078 = validateParameter(valid_590078, JString, required = true,
                                 default = nil)
  if valid_590078 != nil:
    section.add "name", valid_590078
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
  section = newJObject()
  var valid_590079 = query.getOrDefault("upload_protocol")
  valid_590079 = validateParameter(valid_590079, JString, required = false,
                                 default = nil)
  if valid_590079 != nil:
    section.add "upload_protocol", valid_590079
  var valid_590080 = query.getOrDefault("fields")
  valid_590080 = validateParameter(valid_590080, JString, required = false,
                                 default = nil)
  if valid_590080 != nil:
    section.add "fields", valid_590080
  var valid_590081 = query.getOrDefault("quotaUser")
  valid_590081 = validateParameter(valid_590081, JString, required = false,
                                 default = nil)
  if valid_590081 != nil:
    section.add "quotaUser", valid_590081
  var valid_590082 = query.getOrDefault("alt")
  valid_590082 = validateParameter(valid_590082, JString, required = false,
                                 default = newJString("json"))
  if valid_590082 != nil:
    section.add "alt", valid_590082
  var valid_590083 = query.getOrDefault("oauth_token")
  valid_590083 = validateParameter(valid_590083, JString, required = false,
                                 default = nil)
  if valid_590083 != nil:
    section.add "oauth_token", valid_590083
  var valid_590084 = query.getOrDefault("callback")
  valid_590084 = validateParameter(valid_590084, JString, required = false,
                                 default = nil)
  if valid_590084 != nil:
    section.add "callback", valid_590084
  var valid_590085 = query.getOrDefault("access_token")
  valid_590085 = validateParameter(valid_590085, JString, required = false,
                                 default = nil)
  if valid_590085 != nil:
    section.add "access_token", valid_590085
  var valid_590086 = query.getOrDefault("uploadType")
  valid_590086 = validateParameter(valid_590086, JString, required = false,
                                 default = nil)
  if valid_590086 != nil:
    section.add "uploadType", valid_590086
  var valid_590087 = query.getOrDefault("key")
  valid_590087 = validateParameter(valid_590087, JString, required = false,
                                 default = nil)
  if valid_590087 != nil:
    section.add "key", valid_590087
  var valid_590088 = query.getOrDefault("$.xgafv")
  valid_590088 = validateParameter(valid_590088, JString, required = false,
                                 default = newJString("1"))
  if valid_590088 != nil:
    section.add "$.xgafv", valid_590088
  var valid_590089 = query.getOrDefault("prettyPrint")
  valid_590089 = validateParameter(valid_590089, JBool, required = false,
                                 default = newJBool(true))
  if valid_590089 != nil:
    section.add "prettyPrint", valid_590089
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

proc call*(call_590091: Call_ContainerProjectsLocationsClustersStartIpRotation_590075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_590091.validator(path, query, header, formData, body)
  let scheme = call_590091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590091.url(scheme.get, call_590091.host, call_590091.base,
                         call_590091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590091, url, valid)

proc call*(call_590092: Call_ContainerProjectsLocationsClustersStartIpRotation_590075;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersStartIpRotation
  ## Starts master IP rotation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   alt: string
  ##      : Data format for response.
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
  var path_590093 = newJObject()
  var query_590094 = newJObject()
  var body_590095 = newJObject()
  add(query_590094, "upload_protocol", newJString(uploadProtocol))
  add(query_590094, "fields", newJString(fields))
  add(query_590094, "quotaUser", newJString(quotaUser))
  add(path_590093, "name", newJString(name))
  add(query_590094, "alt", newJString(alt))
  add(query_590094, "oauth_token", newJString(oauthToken))
  add(query_590094, "callback", newJString(callback))
  add(query_590094, "access_token", newJString(accessToken))
  add(query_590094, "uploadType", newJString(uploadType))
  add(query_590094, "key", newJString(key))
  add(query_590094, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590095 = body
  add(query_590094, "prettyPrint", newJBool(prettyPrint))
  result = call_590092.call(path_590093, query_590094, nil, nil, body_590095)

var containerProjectsLocationsClustersStartIpRotation* = Call_ContainerProjectsLocationsClustersStartIpRotation_590075(
    name: "containerProjectsLocationsClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:startIpRotation",
    validator: validate_ContainerProjectsLocationsClustersStartIpRotation_590076,
    base: "/", url: url_ContainerProjectsLocationsClustersStartIpRotation_590077,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersUpdateMaster_590096 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersUpdateMaster_590098(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":updateMaster")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersUpdateMaster_590097(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the master for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name (project, location, cluster) of the cluster to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_590099 = path.getOrDefault("name")
  valid_590099 = validateParameter(valid_590099, JString, required = true,
                                 default = nil)
  if valid_590099 != nil:
    section.add "name", valid_590099
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
  section = newJObject()
  var valid_590100 = query.getOrDefault("upload_protocol")
  valid_590100 = validateParameter(valid_590100, JString, required = false,
                                 default = nil)
  if valid_590100 != nil:
    section.add "upload_protocol", valid_590100
  var valid_590101 = query.getOrDefault("fields")
  valid_590101 = validateParameter(valid_590101, JString, required = false,
                                 default = nil)
  if valid_590101 != nil:
    section.add "fields", valid_590101
  var valid_590102 = query.getOrDefault("quotaUser")
  valid_590102 = validateParameter(valid_590102, JString, required = false,
                                 default = nil)
  if valid_590102 != nil:
    section.add "quotaUser", valid_590102
  var valid_590103 = query.getOrDefault("alt")
  valid_590103 = validateParameter(valid_590103, JString, required = false,
                                 default = newJString("json"))
  if valid_590103 != nil:
    section.add "alt", valid_590103
  var valid_590104 = query.getOrDefault("oauth_token")
  valid_590104 = validateParameter(valid_590104, JString, required = false,
                                 default = nil)
  if valid_590104 != nil:
    section.add "oauth_token", valid_590104
  var valid_590105 = query.getOrDefault("callback")
  valid_590105 = validateParameter(valid_590105, JString, required = false,
                                 default = nil)
  if valid_590105 != nil:
    section.add "callback", valid_590105
  var valid_590106 = query.getOrDefault("access_token")
  valid_590106 = validateParameter(valid_590106, JString, required = false,
                                 default = nil)
  if valid_590106 != nil:
    section.add "access_token", valid_590106
  var valid_590107 = query.getOrDefault("uploadType")
  valid_590107 = validateParameter(valid_590107, JString, required = false,
                                 default = nil)
  if valid_590107 != nil:
    section.add "uploadType", valid_590107
  var valid_590108 = query.getOrDefault("key")
  valid_590108 = validateParameter(valid_590108, JString, required = false,
                                 default = nil)
  if valid_590108 != nil:
    section.add "key", valid_590108
  var valid_590109 = query.getOrDefault("$.xgafv")
  valid_590109 = validateParameter(valid_590109, JString, required = false,
                                 default = newJString("1"))
  if valid_590109 != nil:
    section.add "$.xgafv", valid_590109
  var valid_590110 = query.getOrDefault("prettyPrint")
  valid_590110 = validateParameter(valid_590110, JBool, required = false,
                                 default = newJBool(true))
  if valid_590110 != nil:
    section.add "prettyPrint", valid_590110
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

proc call*(call_590112: Call_ContainerProjectsLocationsClustersUpdateMaster_590096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_590112.validator(path, query, header, formData, body)
  let scheme = call_590112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590112.url(scheme.get, call_590112.host, call_590112.base,
                         call_590112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590112, url, valid)

proc call*(call_590113: Call_ContainerProjectsLocationsClustersUpdateMaster_590096;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersUpdateMaster
  ## Updates the master for a specific cluster.
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
  var path_590114 = newJObject()
  var query_590115 = newJObject()
  var body_590116 = newJObject()
  add(query_590115, "upload_protocol", newJString(uploadProtocol))
  add(query_590115, "fields", newJString(fields))
  add(query_590115, "quotaUser", newJString(quotaUser))
  add(path_590114, "name", newJString(name))
  add(query_590115, "alt", newJString(alt))
  add(query_590115, "oauth_token", newJString(oauthToken))
  add(query_590115, "callback", newJString(callback))
  add(query_590115, "access_token", newJString(accessToken))
  add(query_590115, "uploadType", newJString(uploadType))
  add(query_590115, "key", newJString(key))
  add(query_590115, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590116 = body
  add(query_590115, "prettyPrint", newJBool(prettyPrint))
  result = call_590113.call(path_590114, query_590115, nil, nil, body_590116)

var containerProjectsLocationsClustersUpdateMaster* = Call_ContainerProjectsLocationsClustersUpdateMaster_590096(
    name: "containerProjectsLocationsClustersUpdateMaster",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:updateMaster",
    validator: validate_ContainerProjectsLocationsClustersUpdateMaster_590097,
    base: "/", url: url_ContainerProjectsLocationsClustersUpdateMaster_590098,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_590117 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_590119(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"), (kind: ConstantSegment,
        value: "/.well-known/openid-configuration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_590118(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the OIDC discovery document for the cluster.
  ## See the
  ## [OpenID Connect Discovery 1.0
  ## specification](https://openid.net/specs/openid-connect-discovery-1_0.html)
  ## for details.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The cluster (project, location, cluster id) to get the discovery document
  ## for. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590120 = path.getOrDefault("parent")
  valid_590120 = validateParameter(valid_590120, JString, required = true,
                                 default = nil)
  if valid_590120 != nil:
    section.add "parent", valid_590120
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
  section = newJObject()
  var valid_590121 = query.getOrDefault("upload_protocol")
  valid_590121 = validateParameter(valid_590121, JString, required = false,
                                 default = nil)
  if valid_590121 != nil:
    section.add "upload_protocol", valid_590121
  var valid_590122 = query.getOrDefault("fields")
  valid_590122 = validateParameter(valid_590122, JString, required = false,
                                 default = nil)
  if valid_590122 != nil:
    section.add "fields", valid_590122
  var valid_590123 = query.getOrDefault("quotaUser")
  valid_590123 = validateParameter(valid_590123, JString, required = false,
                                 default = nil)
  if valid_590123 != nil:
    section.add "quotaUser", valid_590123
  var valid_590124 = query.getOrDefault("alt")
  valid_590124 = validateParameter(valid_590124, JString, required = false,
                                 default = newJString("json"))
  if valid_590124 != nil:
    section.add "alt", valid_590124
  var valid_590125 = query.getOrDefault("oauth_token")
  valid_590125 = validateParameter(valid_590125, JString, required = false,
                                 default = nil)
  if valid_590125 != nil:
    section.add "oauth_token", valid_590125
  var valid_590126 = query.getOrDefault("callback")
  valid_590126 = validateParameter(valid_590126, JString, required = false,
                                 default = nil)
  if valid_590126 != nil:
    section.add "callback", valid_590126
  var valid_590127 = query.getOrDefault("access_token")
  valid_590127 = validateParameter(valid_590127, JString, required = false,
                                 default = nil)
  if valid_590127 != nil:
    section.add "access_token", valid_590127
  var valid_590128 = query.getOrDefault("uploadType")
  valid_590128 = validateParameter(valid_590128, JString, required = false,
                                 default = nil)
  if valid_590128 != nil:
    section.add "uploadType", valid_590128
  var valid_590129 = query.getOrDefault("key")
  valid_590129 = validateParameter(valid_590129, JString, required = false,
                                 default = nil)
  if valid_590129 != nil:
    section.add "key", valid_590129
  var valid_590130 = query.getOrDefault("$.xgafv")
  valid_590130 = validateParameter(valid_590130, JString, required = false,
                                 default = newJString("1"))
  if valid_590130 != nil:
    section.add "$.xgafv", valid_590130
  var valid_590131 = query.getOrDefault("prettyPrint")
  valid_590131 = validateParameter(valid_590131, JBool, required = false,
                                 default = newJBool(true))
  if valid_590131 != nil:
    section.add "prettyPrint", valid_590131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590132: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_590117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the OIDC discovery document for the cluster.
  ## See the
  ## [OpenID Connect Discovery 1.0
  ## specification](https://openid.net/specs/openid-connect-discovery-1_0.html)
  ## for details.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  let valid = call_590132.validator(path, query, header, formData, body)
  let scheme = call_590132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590132.url(scheme.get, call_590132.host, call_590132.base,
                         call_590132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590132, url, valid)

proc call*(call_590133: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_590117;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersWellKnownGetOpenidConfiguration
  ## Gets the OIDC discovery document for the cluster.
  ## See the
  ## [OpenID Connect Discovery 1.0
  ## specification](https://openid.net/specs/openid-connect-discovery-1_0.html)
  ## for details.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The cluster (project, location, cluster id) to get the discovery document
  ## for. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590134 = newJObject()
  var query_590135 = newJObject()
  add(query_590135, "upload_protocol", newJString(uploadProtocol))
  add(query_590135, "fields", newJString(fields))
  add(query_590135, "quotaUser", newJString(quotaUser))
  add(query_590135, "alt", newJString(alt))
  add(query_590135, "oauth_token", newJString(oauthToken))
  add(query_590135, "callback", newJString(callback))
  add(query_590135, "access_token", newJString(accessToken))
  add(query_590135, "uploadType", newJString(uploadType))
  add(path_590134, "parent", newJString(parent))
  add(query_590135, "key", newJString(key))
  add(query_590135, "$.xgafv", newJString(Xgafv))
  add(query_590135, "prettyPrint", newJBool(prettyPrint))
  result = call_590133.call(path_590134, query_590135, nil, nil, nil)

var containerProjectsLocationsClustersWellKnownGetOpenidConfiguration* = Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_590117(
    name: "containerProjectsLocationsClustersWellKnownGetOpenidConfiguration",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/.well-known/openid-configuration", validator: validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_590118,
    base: "/",
    url: url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_590119,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsAggregatedUsableSubnetworksList_590136 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsAggregatedUsableSubnetworksList_590138(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/aggregated/usableSubnetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsAggregatedUsableSubnetworksList_590137(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists subnetworks that are usable for creating clusters in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent project where subnetworks are usable.
  ## Specified in the format 'projects/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590139 = path.getOrDefault("parent")
  valid_590139 = validateParameter(valid_590139, JString, required = true,
                                 default = nil)
  if valid_590139 != nil:
    section.add "parent", valid_590139
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set this to the nextPageToken returned by
  ## previous list requests to get the next page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  ##   pageSize: JInt
  ##           : The max number of results per page that should be returned. If the number
  ## of available results is larger than `page_size`, a `next_page_token` is
  ## returned which can be used to get the next page of results in subsequent
  ## requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Filtering currently only supports equality on the networkProjectId and must
  ## be in the form: "networkProjectId=[PROJECTID]", where `networkProjectId`
  ## is the project which owns the listed subnetworks. This defaults to the
  ## parent project ID.
  section = newJObject()
  var valid_590140 = query.getOrDefault("upload_protocol")
  valid_590140 = validateParameter(valid_590140, JString, required = false,
                                 default = nil)
  if valid_590140 != nil:
    section.add "upload_protocol", valid_590140
  var valid_590141 = query.getOrDefault("fields")
  valid_590141 = validateParameter(valid_590141, JString, required = false,
                                 default = nil)
  if valid_590141 != nil:
    section.add "fields", valid_590141
  var valid_590142 = query.getOrDefault("pageToken")
  valid_590142 = validateParameter(valid_590142, JString, required = false,
                                 default = nil)
  if valid_590142 != nil:
    section.add "pageToken", valid_590142
  var valid_590143 = query.getOrDefault("quotaUser")
  valid_590143 = validateParameter(valid_590143, JString, required = false,
                                 default = nil)
  if valid_590143 != nil:
    section.add "quotaUser", valid_590143
  var valid_590144 = query.getOrDefault("alt")
  valid_590144 = validateParameter(valid_590144, JString, required = false,
                                 default = newJString("json"))
  if valid_590144 != nil:
    section.add "alt", valid_590144
  var valid_590145 = query.getOrDefault("oauth_token")
  valid_590145 = validateParameter(valid_590145, JString, required = false,
                                 default = nil)
  if valid_590145 != nil:
    section.add "oauth_token", valid_590145
  var valid_590146 = query.getOrDefault("callback")
  valid_590146 = validateParameter(valid_590146, JString, required = false,
                                 default = nil)
  if valid_590146 != nil:
    section.add "callback", valid_590146
  var valid_590147 = query.getOrDefault("access_token")
  valid_590147 = validateParameter(valid_590147, JString, required = false,
                                 default = nil)
  if valid_590147 != nil:
    section.add "access_token", valid_590147
  var valid_590148 = query.getOrDefault("uploadType")
  valid_590148 = validateParameter(valid_590148, JString, required = false,
                                 default = nil)
  if valid_590148 != nil:
    section.add "uploadType", valid_590148
  var valid_590149 = query.getOrDefault("key")
  valid_590149 = validateParameter(valid_590149, JString, required = false,
                                 default = nil)
  if valid_590149 != nil:
    section.add "key", valid_590149
  var valid_590150 = query.getOrDefault("$.xgafv")
  valid_590150 = validateParameter(valid_590150, JString, required = false,
                                 default = newJString("1"))
  if valid_590150 != nil:
    section.add "$.xgafv", valid_590150
  var valid_590151 = query.getOrDefault("pageSize")
  valid_590151 = validateParameter(valid_590151, JInt, required = false, default = nil)
  if valid_590151 != nil:
    section.add "pageSize", valid_590151
  var valid_590152 = query.getOrDefault("prettyPrint")
  valid_590152 = validateParameter(valid_590152, JBool, required = false,
                                 default = newJBool(true))
  if valid_590152 != nil:
    section.add "prettyPrint", valid_590152
  var valid_590153 = query.getOrDefault("filter")
  valid_590153 = validateParameter(valid_590153, JString, required = false,
                                 default = nil)
  if valid_590153 != nil:
    section.add "filter", valid_590153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590154: Call_ContainerProjectsAggregatedUsableSubnetworksList_590136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists subnetworks that are usable for creating clusters in a project.
  ## 
  let valid = call_590154.validator(path, query, header, formData, body)
  let scheme = call_590154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590154.url(scheme.get, call_590154.host, call_590154.base,
                         call_590154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590154, url, valid)

proc call*(call_590155: Call_ContainerProjectsAggregatedUsableSubnetworksList_590136;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## containerProjectsAggregatedUsableSubnetworksList
  ## Lists subnetworks that are usable for creating clusters in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set this to the nextPageToken returned by
  ## previous list requests to get the next page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent project where subnetworks are usable.
  ## Specified in the format 'projects/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The max number of results per page that should be returned. If the number
  ## of available results is larger than `page_size`, a `next_page_token` is
  ## returned which can be used to get the next page of results in subsequent
  ## requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Filtering currently only supports equality on the networkProjectId and must
  ## be in the form: "networkProjectId=[PROJECTID]", where `networkProjectId`
  ## is the project which owns the listed subnetworks. This defaults to the
  ## parent project ID.
  var path_590156 = newJObject()
  var query_590157 = newJObject()
  add(query_590157, "upload_protocol", newJString(uploadProtocol))
  add(query_590157, "fields", newJString(fields))
  add(query_590157, "pageToken", newJString(pageToken))
  add(query_590157, "quotaUser", newJString(quotaUser))
  add(query_590157, "alt", newJString(alt))
  add(query_590157, "oauth_token", newJString(oauthToken))
  add(query_590157, "callback", newJString(callback))
  add(query_590157, "access_token", newJString(accessToken))
  add(query_590157, "uploadType", newJString(uploadType))
  add(path_590156, "parent", newJString(parent))
  add(query_590157, "key", newJString(key))
  add(query_590157, "$.xgafv", newJString(Xgafv))
  add(query_590157, "pageSize", newJInt(pageSize))
  add(query_590157, "prettyPrint", newJBool(prettyPrint))
  add(query_590157, "filter", newJString(filter))
  result = call_590155.call(path_590156, query_590157, nil, nil, nil)

var containerProjectsAggregatedUsableSubnetworksList* = Call_ContainerProjectsAggregatedUsableSubnetworksList_590136(
    name: "containerProjectsAggregatedUsableSubnetworksList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/aggregated/usableSubnetworks",
    validator: validate_ContainerProjectsAggregatedUsableSubnetworksList_590137,
    base: "/", url: url_ContainerProjectsAggregatedUsableSubnetworksList_590138,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCreate_590179 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersCreate_590181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCreate_590180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project and location) where the cluster will be created.
  ## Specified in the format 'projects/*/locations/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590182 = path.getOrDefault("parent")
  valid_590182 = validateParameter(valid_590182, JString, required = true,
                                 default = nil)
  if valid_590182 != nil:
    section.add "parent", valid_590182
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
  section = newJObject()
  var valid_590183 = query.getOrDefault("upload_protocol")
  valid_590183 = validateParameter(valid_590183, JString, required = false,
                                 default = nil)
  if valid_590183 != nil:
    section.add "upload_protocol", valid_590183
  var valid_590184 = query.getOrDefault("fields")
  valid_590184 = validateParameter(valid_590184, JString, required = false,
                                 default = nil)
  if valid_590184 != nil:
    section.add "fields", valid_590184
  var valid_590185 = query.getOrDefault("quotaUser")
  valid_590185 = validateParameter(valid_590185, JString, required = false,
                                 default = nil)
  if valid_590185 != nil:
    section.add "quotaUser", valid_590185
  var valid_590186 = query.getOrDefault("alt")
  valid_590186 = validateParameter(valid_590186, JString, required = false,
                                 default = newJString("json"))
  if valid_590186 != nil:
    section.add "alt", valid_590186
  var valid_590187 = query.getOrDefault("oauth_token")
  valid_590187 = validateParameter(valid_590187, JString, required = false,
                                 default = nil)
  if valid_590187 != nil:
    section.add "oauth_token", valid_590187
  var valid_590188 = query.getOrDefault("callback")
  valid_590188 = validateParameter(valid_590188, JString, required = false,
                                 default = nil)
  if valid_590188 != nil:
    section.add "callback", valid_590188
  var valid_590189 = query.getOrDefault("access_token")
  valid_590189 = validateParameter(valid_590189, JString, required = false,
                                 default = nil)
  if valid_590189 != nil:
    section.add "access_token", valid_590189
  var valid_590190 = query.getOrDefault("uploadType")
  valid_590190 = validateParameter(valid_590190, JString, required = false,
                                 default = nil)
  if valid_590190 != nil:
    section.add "uploadType", valid_590190
  var valid_590191 = query.getOrDefault("key")
  valid_590191 = validateParameter(valid_590191, JString, required = false,
                                 default = nil)
  if valid_590191 != nil:
    section.add "key", valid_590191
  var valid_590192 = query.getOrDefault("$.xgafv")
  valid_590192 = validateParameter(valid_590192, JString, required = false,
                                 default = newJString("1"))
  if valid_590192 != nil:
    section.add "$.xgafv", valid_590192
  var valid_590193 = query.getOrDefault("prettyPrint")
  valid_590193 = validateParameter(valid_590193, JBool, required = false,
                                 default = newJBool(true))
  if valid_590193 != nil:
    section.add "prettyPrint", valid_590193
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

proc call*(call_590195: Call_ContainerProjectsLocationsClustersCreate_590179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ## 
  let valid = call_590195.validator(path, query, header, formData, body)
  let scheme = call_590195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590195.url(scheme.get, call_590195.host, call_590195.base,
                         call_590195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590195, url, valid)

proc call*(call_590196: Call_ContainerProjectsLocationsClustersCreate_590179;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersCreate
  ## Creates a cluster, consisting of the specified number and type of Google
  ## Compute Engine instances.
  ## 
  ## By default, the cluster is created in the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## One firewall is added for the cluster. After cluster creation,
  ## the Kubelet creates routes for each node to allow the containers
  ## on that node to communicate with all other instances in the
  ## cluster.
  ## 
  ## Finally, an entry is added to the project's global metadata indicating
  ## which CIDR range the cluster is using.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var path_590197 = newJObject()
  var query_590198 = newJObject()
  var body_590199 = newJObject()
  add(query_590198, "upload_protocol", newJString(uploadProtocol))
  add(query_590198, "fields", newJString(fields))
  add(query_590198, "quotaUser", newJString(quotaUser))
  add(query_590198, "alt", newJString(alt))
  add(query_590198, "oauth_token", newJString(oauthToken))
  add(query_590198, "callback", newJString(callback))
  add(query_590198, "access_token", newJString(accessToken))
  add(query_590198, "uploadType", newJString(uploadType))
  add(path_590197, "parent", newJString(parent))
  add(query_590198, "key", newJString(key))
  add(query_590198, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590199 = body
  add(query_590198, "prettyPrint", newJBool(prettyPrint))
  result = call_590196.call(path_590197, query_590198, nil, nil, body_590199)

var containerProjectsLocationsClustersCreate* = Call_ContainerProjectsLocationsClustersCreate_590179(
    name: "containerProjectsLocationsClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersCreate_590180,
    base: "/", url: url_ContainerProjectsLocationsClustersCreate_590181,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersList_590158 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersList_590160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersList_590159(path: JsonNode;
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
  var valid_590161 = path.getOrDefault("parent")
  valid_590161 = validateParameter(valid_590161, JString, required = true,
                                 default = nil)
  if valid_590161 != nil:
    section.add "parent", valid_590161
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590162 = query.getOrDefault("upload_protocol")
  valid_590162 = validateParameter(valid_590162, JString, required = false,
                                 default = nil)
  if valid_590162 != nil:
    section.add "upload_protocol", valid_590162
  var valid_590163 = query.getOrDefault("fields")
  valid_590163 = validateParameter(valid_590163, JString, required = false,
                                 default = nil)
  if valid_590163 != nil:
    section.add "fields", valid_590163
  var valid_590164 = query.getOrDefault("quotaUser")
  valid_590164 = validateParameter(valid_590164, JString, required = false,
                                 default = nil)
  if valid_590164 != nil:
    section.add "quotaUser", valid_590164
  var valid_590165 = query.getOrDefault("alt")
  valid_590165 = validateParameter(valid_590165, JString, required = false,
                                 default = newJString("json"))
  if valid_590165 != nil:
    section.add "alt", valid_590165
  var valid_590166 = query.getOrDefault("oauth_token")
  valid_590166 = validateParameter(valid_590166, JString, required = false,
                                 default = nil)
  if valid_590166 != nil:
    section.add "oauth_token", valid_590166
  var valid_590167 = query.getOrDefault("callback")
  valid_590167 = validateParameter(valid_590167, JString, required = false,
                                 default = nil)
  if valid_590167 != nil:
    section.add "callback", valid_590167
  var valid_590168 = query.getOrDefault("access_token")
  valid_590168 = validateParameter(valid_590168, JString, required = false,
                                 default = nil)
  if valid_590168 != nil:
    section.add "access_token", valid_590168
  var valid_590169 = query.getOrDefault("uploadType")
  valid_590169 = validateParameter(valid_590169, JString, required = false,
                                 default = nil)
  if valid_590169 != nil:
    section.add "uploadType", valid_590169
  var valid_590170 = query.getOrDefault("zone")
  valid_590170 = validateParameter(valid_590170, JString, required = false,
                                 default = nil)
  if valid_590170 != nil:
    section.add "zone", valid_590170
  var valid_590171 = query.getOrDefault("key")
  valid_590171 = validateParameter(valid_590171, JString, required = false,
                                 default = nil)
  if valid_590171 != nil:
    section.add "key", valid_590171
  var valid_590172 = query.getOrDefault("$.xgafv")
  valid_590172 = validateParameter(valid_590172, JString, required = false,
                                 default = newJString("1"))
  if valid_590172 != nil:
    section.add "$.xgafv", valid_590172
  var valid_590173 = query.getOrDefault("projectId")
  valid_590173 = validateParameter(valid_590173, JString, required = false,
                                 default = nil)
  if valid_590173 != nil:
    section.add "projectId", valid_590173
  var valid_590174 = query.getOrDefault("prettyPrint")
  valid_590174 = validateParameter(valid_590174, JBool, required = false,
                                 default = newJBool(true))
  if valid_590174 != nil:
    section.add "prettyPrint", valid_590174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590175: Call_ContainerProjectsLocationsClustersList_590158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_590175.validator(path, query, header, formData, body)
  let scheme = call_590175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590175.url(scheme.get, call_590175.host, call_590175.base,
                         call_590175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590175, url, valid)

proc call*(call_590176: Call_ContainerProjectsLocationsClustersList_590158;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          zone: string = ""; key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
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
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590177 = newJObject()
  var query_590178 = newJObject()
  add(query_590178, "upload_protocol", newJString(uploadProtocol))
  add(query_590178, "fields", newJString(fields))
  add(query_590178, "quotaUser", newJString(quotaUser))
  add(query_590178, "alt", newJString(alt))
  add(query_590178, "oauth_token", newJString(oauthToken))
  add(query_590178, "callback", newJString(callback))
  add(query_590178, "access_token", newJString(accessToken))
  add(query_590178, "uploadType", newJString(uploadType))
  add(path_590177, "parent", newJString(parent))
  add(query_590178, "zone", newJString(zone))
  add(query_590178, "key", newJString(key))
  add(query_590178, "$.xgafv", newJString(Xgafv))
  add(query_590178, "projectId", newJString(projectId))
  add(query_590178, "prettyPrint", newJBool(prettyPrint))
  result = call_590176.call(path_590177, query_590178, nil, nil, nil)

var containerProjectsLocationsClustersList* = Call_ContainerProjectsLocationsClustersList_590158(
    name: "containerProjectsLocationsClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersList_590159, base: "/",
    url: url_ContainerProjectsLocationsClustersList_590160,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersGetJwks_590200 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersGetJwks_590202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/jwks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersGetJwks_590201(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The cluster (project, location, cluster id) to get keys for. Specified in
  ## the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590203 = path.getOrDefault("parent")
  valid_590203 = validateParameter(valid_590203, JString, required = true,
                                 default = nil)
  if valid_590203 != nil:
    section.add "parent", valid_590203
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
  section = newJObject()
  var valid_590204 = query.getOrDefault("upload_protocol")
  valid_590204 = validateParameter(valid_590204, JString, required = false,
                                 default = nil)
  if valid_590204 != nil:
    section.add "upload_protocol", valid_590204
  var valid_590205 = query.getOrDefault("fields")
  valid_590205 = validateParameter(valid_590205, JString, required = false,
                                 default = nil)
  if valid_590205 != nil:
    section.add "fields", valid_590205
  var valid_590206 = query.getOrDefault("quotaUser")
  valid_590206 = validateParameter(valid_590206, JString, required = false,
                                 default = nil)
  if valid_590206 != nil:
    section.add "quotaUser", valid_590206
  var valid_590207 = query.getOrDefault("alt")
  valid_590207 = validateParameter(valid_590207, JString, required = false,
                                 default = newJString("json"))
  if valid_590207 != nil:
    section.add "alt", valid_590207
  var valid_590208 = query.getOrDefault("oauth_token")
  valid_590208 = validateParameter(valid_590208, JString, required = false,
                                 default = nil)
  if valid_590208 != nil:
    section.add "oauth_token", valid_590208
  var valid_590209 = query.getOrDefault("callback")
  valid_590209 = validateParameter(valid_590209, JString, required = false,
                                 default = nil)
  if valid_590209 != nil:
    section.add "callback", valid_590209
  var valid_590210 = query.getOrDefault("access_token")
  valid_590210 = validateParameter(valid_590210, JString, required = false,
                                 default = nil)
  if valid_590210 != nil:
    section.add "access_token", valid_590210
  var valid_590211 = query.getOrDefault("uploadType")
  valid_590211 = validateParameter(valid_590211, JString, required = false,
                                 default = nil)
  if valid_590211 != nil:
    section.add "uploadType", valid_590211
  var valid_590212 = query.getOrDefault("key")
  valid_590212 = validateParameter(valid_590212, JString, required = false,
                                 default = nil)
  if valid_590212 != nil:
    section.add "key", valid_590212
  var valid_590213 = query.getOrDefault("$.xgafv")
  valid_590213 = validateParameter(valid_590213, JString, required = false,
                                 default = newJString("1"))
  if valid_590213 != nil:
    section.add "$.xgafv", valid_590213
  var valid_590214 = query.getOrDefault("prettyPrint")
  valid_590214 = validateParameter(valid_590214, JBool, required = false,
                                 default = newJBool(true))
  if valid_590214 != nil:
    section.add "prettyPrint", valid_590214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590215: Call_ContainerProjectsLocationsClustersGetJwks_590200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  let valid = call_590215.validator(path, query, header, formData, body)
  let scheme = call_590215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590215.url(scheme.get, call_590215.host, call_590215.base,
                         call_590215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590215, url, valid)

proc call*(call_590216: Call_ContainerProjectsLocationsClustersGetJwks_590200;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## containerProjectsLocationsClustersGetJwks
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The cluster (project, location, cluster id) to get keys for. Specified in
  ## the format 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590217 = newJObject()
  var query_590218 = newJObject()
  add(query_590218, "upload_protocol", newJString(uploadProtocol))
  add(query_590218, "fields", newJString(fields))
  add(query_590218, "quotaUser", newJString(quotaUser))
  add(query_590218, "alt", newJString(alt))
  add(query_590218, "oauth_token", newJString(oauthToken))
  add(query_590218, "callback", newJString(callback))
  add(query_590218, "access_token", newJString(accessToken))
  add(query_590218, "uploadType", newJString(uploadType))
  add(path_590217, "parent", newJString(parent))
  add(query_590218, "key", newJString(key))
  add(query_590218, "$.xgafv", newJString(Xgafv))
  add(query_590218, "prettyPrint", newJBool(prettyPrint))
  result = call_590216.call(path_590217, query_590218, nil, nil, nil)

var containerProjectsLocationsClustersGetJwks* = Call_ContainerProjectsLocationsClustersGetJwks_590200(
    name: "containerProjectsLocationsClustersGetJwks", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/jwks",
    validator: validate_ContainerProjectsLocationsClustersGetJwks_590201,
    base: "/", url: url_ContainerProjectsLocationsClustersGetJwks_590202,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsCreate_590241 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsCreate_590243(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsCreate_590242(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project, location, cluster id) where the node pool will be
  ## created. Specified in the format
  ## 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590244 = path.getOrDefault("parent")
  valid_590244 = validateParameter(valid_590244, JString, required = true,
                                 default = nil)
  if valid_590244 != nil:
    section.add "parent", valid_590244
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
  section = newJObject()
  var valid_590245 = query.getOrDefault("upload_protocol")
  valid_590245 = validateParameter(valid_590245, JString, required = false,
                                 default = nil)
  if valid_590245 != nil:
    section.add "upload_protocol", valid_590245
  var valid_590246 = query.getOrDefault("fields")
  valid_590246 = validateParameter(valid_590246, JString, required = false,
                                 default = nil)
  if valid_590246 != nil:
    section.add "fields", valid_590246
  var valid_590247 = query.getOrDefault("quotaUser")
  valid_590247 = validateParameter(valid_590247, JString, required = false,
                                 default = nil)
  if valid_590247 != nil:
    section.add "quotaUser", valid_590247
  var valid_590248 = query.getOrDefault("alt")
  valid_590248 = validateParameter(valid_590248, JString, required = false,
                                 default = newJString("json"))
  if valid_590248 != nil:
    section.add "alt", valid_590248
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

proc call*(call_590257: Call_ContainerProjectsLocationsClustersNodePoolsCreate_590241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_590257.validator(path, query, header, formData, body)
  let scheme = call_590257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590257.url(scheme.get, call_590257.host, call_590257.base,
                         call_590257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590257, url, valid)

proc call*(call_590258: Call_ContainerProjectsLocationsClustersNodePoolsCreate_590241;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pool will be
  ## created. Specified in the format
  ## 'projects/*/locations/*/clusters/*'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590259 = newJObject()
  var query_590260 = newJObject()
  var body_590261 = newJObject()
  add(query_590260, "upload_protocol", newJString(uploadProtocol))
  add(query_590260, "fields", newJString(fields))
  add(query_590260, "quotaUser", newJString(quotaUser))
  add(query_590260, "alt", newJString(alt))
  add(query_590260, "oauth_token", newJString(oauthToken))
  add(query_590260, "callback", newJString(callback))
  add(query_590260, "access_token", newJString(accessToken))
  add(query_590260, "uploadType", newJString(uploadType))
  add(path_590259, "parent", newJString(parent))
  add(query_590260, "key", newJString(key))
  add(query_590260, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_590261 = body
  add(query_590260, "prettyPrint", newJBool(prettyPrint))
  result = call_590258.call(path_590259, query_590260, nil, nil, body_590261)

var containerProjectsLocationsClustersNodePoolsCreate* = Call_ContainerProjectsLocationsClustersNodePoolsCreate_590241(
    name: "containerProjectsLocationsClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsCreate_590242,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsCreate_590243,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsList_590219 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsClustersNodePoolsList_590221(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodePools")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsList_590220(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_590222 = path.getOrDefault("parent")
  valid_590222 = validateParameter(valid_590222, JString, required = true,
                                 default = nil)
  if valid_590222 != nil:
    section.add "parent", valid_590222
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: JString
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  var valid_590223 = query.getOrDefault("upload_protocol")
  valid_590223 = validateParameter(valid_590223, JString, required = false,
                                 default = nil)
  if valid_590223 != nil:
    section.add "upload_protocol", valid_590223
  var valid_590224 = query.getOrDefault("fields")
  valid_590224 = validateParameter(valid_590224, JString, required = false,
                                 default = nil)
  if valid_590224 != nil:
    section.add "fields", valid_590224
  var valid_590225 = query.getOrDefault("quotaUser")
  valid_590225 = validateParameter(valid_590225, JString, required = false,
                                 default = nil)
  if valid_590225 != nil:
    section.add "quotaUser", valid_590225
  var valid_590226 = query.getOrDefault("alt")
  valid_590226 = validateParameter(valid_590226, JString, required = false,
                                 default = newJString("json"))
  if valid_590226 != nil:
    section.add "alt", valid_590226
  var valid_590227 = query.getOrDefault("oauth_token")
  valid_590227 = validateParameter(valid_590227, JString, required = false,
                                 default = nil)
  if valid_590227 != nil:
    section.add "oauth_token", valid_590227
  var valid_590228 = query.getOrDefault("callback")
  valid_590228 = validateParameter(valid_590228, JString, required = false,
                                 default = nil)
  if valid_590228 != nil:
    section.add "callback", valid_590228
  var valid_590229 = query.getOrDefault("access_token")
  valid_590229 = validateParameter(valid_590229, JString, required = false,
                                 default = nil)
  if valid_590229 != nil:
    section.add "access_token", valid_590229
  var valid_590230 = query.getOrDefault("uploadType")
  valid_590230 = validateParameter(valid_590230, JString, required = false,
                                 default = nil)
  if valid_590230 != nil:
    section.add "uploadType", valid_590230
  var valid_590231 = query.getOrDefault("zone")
  valid_590231 = validateParameter(valid_590231, JString, required = false,
                                 default = nil)
  if valid_590231 != nil:
    section.add "zone", valid_590231
  var valid_590232 = query.getOrDefault("key")
  valid_590232 = validateParameter(valid_590232, JString, required = false,
                                 default = nil)
  if valid_590232 != nil:
    section.add "key", valid_590232
  var valid_590233 = query.getOrDefault("$.xgafv")
  valid_590233 = validateParameter(valid_590233, JString, required = false,
                                 default = newJString("1"))
  if valid_590233 != nil:
    section.add "$.xgafv", valid_590233
  var valid_590234 = query.getOrDefault("projectId")
  valid_590234 = validateParameter(valid_590234, JString, required = false,
                                 default = nil)
  if valid_590234 != nil:
    section.add "projectId", valid_590234
  var valid_590235 = query.getOrDefault("prettyPrint")
  valid_590235 = validateParameter(valid_590235, JBool, required = false,
                                 default = newJBool(true))
  if valid_590235 != nil:
    section.add "prettyPrint", valid_590235
  var valid_590236 = query.getOrDefault("clusterId")
  valid_590236 = validateParameter(valid_590236, JString, required = false,
                                 default = nil)
  if valid_590236 != nil:
    section.add "clusterId", valid_590236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590237: Call_ContainerProjectsLocationsClustersNodePoolsList_590219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_590237.validator(path, query, header, formData, body)
  let scheme = call_590237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590237.url(scheme.get, call_590237.host, call_590237.base,
                         call_590237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590237, url, valid)

proc call*(call_590238: Call_ContainerProjectsLocationsClustersNodePoolsList_590219;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          zone: string = ""; key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true; clusterId: string = ""): Recallable =
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
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  var path_590239 = newJObject()
  var query_590240 = newJObject()
  add(query_590240, "upload_protocol", newJString(uploadProtocol))
  add(query_590240, "fields", newJString(fields))
  add(query_590240, "quotaUser", newJString(quotaUser))
  add(query_590240, "alt", newJString(alt))
  add(query_590240, "oauth_token", newJString(oauthToken))
  add(query_590240, "callback", newJString(callback))
  add(query_590240, "access_token", newJString(accessToken))
  add(query_590240, "uploadType", newJString(uploadType))
  add(path_590239, "parent", newJString(parent))
  add(query_590240, "zone", newJString(zone))
  add(query_590240, "key", newJString(key))
  add(query_590240, "$.xgafv", newJString(Xgafv))
  add(query_590240, "projectId", newJString(projectId))
  add(query_590240, "prettyPrint", newJBool(prettyPrint))
  add(query_590240, "clusterId", newJString(clusterId))
  result = call_590238.call(path_590239, query_590240, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsList* = Call_ContainerProjectsLocationsClustersNodePoolsList_590219(
    name: "containerProjectsLocationsClustersNodePoolsList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsList_590220,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsList_590221,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsList_590262 = ref object of OpenApiRestCall_588450
proc url_ContainerProjectsLocationsOperationsList_590264(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsList_590263(path: JsonNode;
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
  var valid_590265 = path.getOrDefault("parent")
  valid_590265 = validateParameter(valid_590265, JString, required = true,
                                 default = nil)
  if valid_590265 != nil:
    section.add "parent", valid_590265
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590266 = query.getOrDefault("upload_protocol")
  valid_590266 = validateParameter(valid_590266, JString, required = false,
                                 default = nil)
  if valid_590266 != nil:
    section.add "upload_protocol", valid_590266
  var valid_590267 = query.getOrDefault("fields")
  valid_590267 = validateParameter(valid_590267, JString, required = false,
                                 default = nil)
  if valid_590267 != nil:
    section.add "fields", valid_590267
  var valid_590268 = query.getOrDefault("quotaUser")
  valid_590268 = validateParameter(valid_590268, JString, required = false,
                                 default = nil)
  if valid_590268 != nil:
    section.add "quotaUser", valid_590268
  var valid_590269 = query.getOrDefault("alt")
  valid_590269 = validateParameter(valid_590269, JString, required = false,
                                 default = newJString("json"))
  if valid_590269 != nil:
    section.add "alt", valid_590269
  var valid_590270 = query.getOrDefault("oauth_token")
  valid_590270 = validateParameter(valid_590270, JString, required = false,
                                 default = nil)
  if valid_590270 != nil:
    section.add "oauth_token", valid_590270
  var valid_590271 = query.getOrDefault("callback")
  valid_590271 = validateParameter(valid_590271, JString, required = false,
                                 default = nil)
  if valid_590271 != nil:
    section.add "callback", valid_590271
  var valid_590272 = query.getOrDefault("access_token")
  valid_590272 = validateParameter(valid_590272, JString, required = false,
                                 default = nil)
  if valid_590272 != nil:
    section.add "access_token", valid_590272
  var valid_590273 = query.getOrDefault("uploadType")
  valid_590273 = validateParameter(valid_590273, JString, required = false,
                                 default = nil)
  if valid_590273 != nil:
    section.add "uploadType", valid_590273
  var valid_590274 = query.getOrDefault("zone")
  valid_590274 = validateParameter(valid_590274, JString, required = false,
                                 default = nil)
  if valid_590274 != nil:
    section.add "zone", valid_590274
  var valid_590275 = query.getOrDefault("key")
  valid_590275 = validateParameter(valid_590275, JString, required = false,
                                 default = nil)
  if valid_590275 != nil:
    section.add "key", valid_590275
  var valid_590276 = query.getOrDefault("$.xgafv")
  valid_590276 = validateParameter(valid_590276, JString, required = false,
                                 default = newJString("1"))
  if valid_590276 != nil:
    section.add "$.xgafv", valid_590276
  var valid_590277 = query.getOrDefault("projectId")
  valid_590277 = validateParameter(valid_590277, JString, required = false,
                                 default = nil)
  if valid_590277 != nil:
    section.add "projectId", valid_590277
  var valid_590278 = query.getOrDefault("prettyPrint")
  valid_590278 = validateParameter(valid_590278, JBool, required = false,
                                 default = newJBool(true))
  if valid_590278 != nil:
    section.add "prettyPrint", valid_590278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590279: Call_ContainerProjectsLocationsOperationsList_590262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_590279.validator(path, query, header, formData, body)
  let scheme = call_590279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590279.url(scheme.get, call_590279.host, call_590279.base,
                         call_590279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590279, url, valid)

proc call*(call_590280: Call_ContainerProjectsLocationsOperationsList_590262;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          zone: string = ""; key: string = ""; Xgafv: string = "1"; projectId: string = "";
          prettyPrint: bool = true): Recallable =
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
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590281 = newJObject()
  var query_590282 = newJObject()
  add(query_590282, "upload_protocol", newJString(uploadProtocol))
  add(query_590282, "fields", newJString(fields))
  add(query_590282, "quotaUser", newJString(quotaUser))
  add(query_590282, "alt", newJString(alt))
  add(query_590282, "oauth_token", newJString(oauthToken))
  add(query_590282, "callback", newJString(callback))
  add(query_590282, "access_token", newJString(accessToken))
  add(query_590282, "uploadType", newJString(uploadType))
  add(path_590281, "parent", newJString(parent))
  add(query_590282, "zone", newJString(zone))
  add(query_590282, "key", newJString(key))
  add(query_590282, "$.xgafv", newJString(Xgafv))
  add(query_590282, "projectId", newJString(projectId))
  add(query_590282, "prettyPrint", newJBool(prettyPrint))
  result = call_590280.call(path_590281, query_590282, nil, nil, nil)

var containerProjectsLocationsOperationsList* = Call_ContainerProjectsLocationsOperationsList_590262(
    name: "containerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/operations",
    validator: validate_ContainerProjectsLocationsOperationsList_590263,
    base: "/", url: url_ContainerProjectsLocationsOperationsList_590264,
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
