
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  gcpServiceName = "container"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContainerProjectsZonesClustersCreate_579934 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersCreate_579936(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersCreate_579935(path: JsonNode;
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
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579937 = path.getOrDefault("projectId")
  valid_579937 = validateParameter(valid_579937, JString, required = true,
                                 default = nil)
  if valid_579937 != nil:
    section.add "projectId", valid_579937
  var valid_579938 = path.getOrDefault("zone")
  valid_579938 = validateParameter(valid_579938, JString, required = true,
                                 default = nil)
  if valid_579938 != nil:
    section.add "zone", valid_579938
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579939 = query.getOrDefault("key")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "key", valid_579939
  var valid_579940 = query.getOrDefault("prettyPrint")
  valid_579940 = validateParameter(valid_579940, JBool, required = false,
                                 default = newJBool(true))
  if valid_579940 != nil:
    section.add "prettyPrint", valid_579940
  var valid_579941 = query.getOrDefault("oauth_token")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "oauth_token", valid_579941
  var valid_579942 = query.getOrDefault("$.xgafv")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = newJString("1"))
  if valid_579942 != nil:
    section.add "$.xgafv", valid_579942
  var valid_579943 = query.getOrDefault("alt")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = newJString("json"))
  if valid_579943 != nil:
    section.add "alt", valid_579943
  var valid_579944 = query.getOrDefault("uploadType")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "uploadType", valid_579944
  var valid_579945 = query.getOrDefault("quotaUser")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "quotaUser", valid_579945
  var valid_579946 = query.getOrDefault("callback")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "callback", valid_579946
  var valid_579947 = query.getOrDefault("fields")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "fields", valid_579947
  var valid_579948 = query.getOrDefault("access_token")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "access_token", valid_579948
  var valid_579949 = query.getOrDefault("upload_protocol")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "upload_protocol", valid_579949
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

proc call*(call_579951: Call_ContainerProjectsZonesClustersCreate_579934;
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
  let valid = call_579951.validator(path, query, header, formData, body)
  let scheme = call_579951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579951.url(scheme.get, call_579951.host, call_579951.base,
                         call_579951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579951, url, valid)

proc call*(call_579952: Call_ContainerProjectsZonesClustersCreate_579934;
          projectId: string; zone: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579953 = newJObject()
  var query_579954 = newJObject()
  var body_579955 = newJObject()
  add(query_579954, "key", newJString(key))
  add(query_579954, "prettyPrint", newJBool(prettyPrint))
  add(query_579954, "oauth_token", newJString(oauthToken))
  add(path_579953, "projectId", newJString(projectId))
  add(query_579954, "$.xgafv", newJString(Xgafv))
  add(query_579954, "alt", newJString(alt))
  add(query_579954, "uploadType", newJString(uploadType))
  add(query_579954, "quotaUser", newJString(quotaUser))
  add(path_579953, "zone", newJString(zone))
  if body != nil:
    body_579955 = body
  add(query_579954, "callback", newJString(callback))
  add(query_579954, "fields", newJString(fields))
  add(query_579954, "access_token", newJString(accessToken))
  add(query_579954, "upload_protocol", newJString(uploadProtocol))
  result = call_579952.call(path_579953, query_579954, nil, nil, body_579955)

var containerProjectsZonesClustersCreate* = Call_ContainerProjectsZonesClustersCreate_579934(
    name: "containerProjectsZonesClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersCreate_579935, base: "/",
    url: url_ContainerProjectsZonesClustersCreate_579936, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersList_579644 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersList_579646(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersList_579645(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579772 = path.getOrDefault("projectId")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "projectId", valid_579772
  var valid_579773 = path.getOrDefault("zone")
  valid_579773 = validateParameter(valid_579773, JString, required = true,
                                 default = nil)
  if valid_579773 != nil:
    section.add "zone", valid_579773
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579774 = query.getOrDefault("key")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "key", valid_579774
  var valid_579788 = query.getOrDefault("prettyPrint")
  valid_579788 = validateParameter(valid_579788, JBool, required = false,
                                 default = newJBool(true))
  if valid_579788 != nil:
    section.add "prettyPrint", valid_579788
  var valid_579789 = query.getOrDefault("oauth_token")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "oauth_token", valid_579789
  var valid_579790 = query.getOrDefault("$.xgafv")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = newJString("1"))
  if valid_579790 != nil:
    section.add "$.xgafv", valid_579790
  var valid_579791 = query.getOrDefault("alt")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = newJString("json"))
  if valid_579791 != nil:
    section.add "alt", valid_579791
  var valid_579792 = query.getOrDefault("uploadType")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "uploadType", valid_579792
  var valid_579793 = query.getOrDefault("parent")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "parent", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579795 = query.getOrDefault("callback")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "callback", valid_579795
  var valid_579796 = query.getOrDefault("fields")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "fields", valid_579796
  var valid_579797 = query.getOrDefault("access_token")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "access_token", valid_579797
  var valid_579798 = query.getOrDefault("upload_protocol")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "upload_protocol", valid_579798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579821: Call_ContainerProjectsZonesClustersList_579644;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_579821.validator(path, query, header, formData, body)
  let scheme = call_579821.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579821.url(scheme.get, call_579821.host, call_579821.base,
                         call_579821.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579821, url, valid)

proc call*(call_579892: Call_ContainerProjectsZonesClustersList_579644;
          projectId: string; zone: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579893 = newJObject()
  var query_579895 = newJObject()
  add(query_579895, "key", newJString(key))
  add(query_579895, "prettyPrint", newJBool(prettyPrint))
  add(query_579895, "oauth_token", newJString(oauthToken))
  add(path_579893, "projectId", newJString(projectId))
  add(query_579895, "$.xgafv", newJString(Xgafv))
  add(query_579895, "alt", newJString(alt))
  add(query_579895, "uploadType", newJString(uploadType))
  add(query_579895, "parent", newJString(parent))
  add(query_579895, "quotaUser", newJString(quotaUser))
  add(path_579893, "zone", newJString(zone))
  add(query_579895, "callback", newJString(callback))
  add(query_579895, "fields", newJString(fields))
  add(query_579895, "access_token", newJString(accessToken))
  add(query_579895, "upload_protocol", newJString(uploadProtocol))
  result = call_579892.call(path_579893, query_579895, nil, nil, nil)

var containerProjectsZonesClustersList* = Call_ContainerProjectsZonesClustersList_579644(
    name: "containerProjectsZonesClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersList_579645, base: "/",
    url: url_ContainerProjectsZonesClustersList_579646, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersUpdate_579978 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersUpdate_579980(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersUpdate_579979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the settings of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579981 = path.getOrDefault("projectId")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "projectId", valid_579981
  var valid_579982 = path.getOrDefault("clusterId")
  valid_579982 = validateParameter(valid_579982, JString, required = true,
                                 default = nil)
  if valid_579982 != nil:
    section.add "clusterId", valid_579982
  var valid_579983 = path.getOrDefault("zone")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "zone", valid_579983
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("$.xgafv")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("1"))
  if valid_579987 != nil:
    section.add "$.xgafv", valid_579987
  var valid_579988 = query.getOrDefault("alt")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("json"))
  if valid_579988 != nil:
    section.add "alt", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("callback")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "callback", valid_579991
  var valid_579992 = query.getOrDefault("fields")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "fields", valid_579992
  var valid_579993 = query.getOrDefault("access_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "access_token", valid_579993
  var valid_579994 = query.getOrDefault("upload_protocol")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "upload_protocol", valid_579994
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

proc call*(call_579996: Call_ContainerProjectsZonesClustersUpdate_579978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific cluster.
  ## 
  let valid = call_579996.validator(path, query, header, formData, body)
  let scheme = call_579996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579996.url(scheme.get, call_579996.host, call_579996.base,
                         call_579996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579996, url, valid)

proc call*(call_579997: Call_ContainerProjectsZonesClustersUpdate_579978;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersUpdate
  ## Updates the settings of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579998 = newJObject()
  var query_579999 = newJObject()
  var body_580000 = newJObject()
  add(query_579999, "key", newJString(key))
  add(query_579999, "prettyPrint", newJBool(prettyPrint))
  add(query_579999, "oauth_token", newJString(oauthToken))
  add(path_579998, "projectId", newJString(projectId))
  add(query_579999, "$.xgafv", newJString(Xgafv))
  add(query_579999, "alt", newJString(alt))
  add(query_579999, "uploadType", newJString(uploadType))
  add(query_579999, "quotaUser", newJString(quotaUser))
  add(path_579998, "clusterId", newJString(clusterId))
  add(path_579998, "zone", newJString(zone))
  if body != nil:
    body_580000 = body
  add(query_579999, "callback", newJString(callback))
  add(query_579999, "fields", newJString(fields))
  add(query_579999, "access_token", newJString(accessToken))
  add(query_579999, "upload_protocol", newJString(uploadProtocol))
  result = call_579997.call(path_579998, query_579999, nil, nil, body_580000)

var containerProjectsZonesClustersUpdate* = Call_ContainerProjectsZonesClustersUpdate_579978(
    name: "containerProjectsZonesClustersUpdate", meth: HttpMethod.HttpPut,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersUpdate_579979, base: "/",
    url: url_ContainerProjectsZonesClustersUpdate_579980, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersGet_579956 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersGet_579958(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersGet_579957(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to retrieve.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579959 = path.getOrDefault("projectId")
  valid_579959 = validateParameter(valid_579959, JString, required = true,
                                 default = nil)
  if valid_579959 != nil:
    section.add "projectId", valid_579959
  var valid_579960 = path.getOrDefault("clusterId")
  valid_579960 = validateParameter(valid_579960, JString, required = true,
                                 default = nil)
  if valid_579960 != nil:
    section.add "clusterId", valid_579960
  var valid_579961 = path.getOrDefault("zone")
  valid_579961 = validateParameter(valid_579961, JString, required = true,
                                 default = nil)
  if valid_579961 != nil:
    section.add "zone", valid_579961
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, cluster) of the cluster to retrieve.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579962 = query.getOrDefault("key")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "key", valid_579962
  var valid_579963 = query.getOrDefault("prettyPrint")
  valid_579963 = validateParameter(valid_579963, JBool, required = false,
                                 default = newJBool(true))
  if valid_579963 != nil:
    section.add "prettyPrint", valid_579963
  var valid_579964 = query.getOrDefault("oauth_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "oauth_token", valid_579964
  var valid_579965 = query.getOrDefault("name")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "name", valid_579965
  var valid_579966 = query.getOrDefault("$.xgafv")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("1"))
  if valid_579966 != nil:
    section.add "$.xgafv", valid_579966
  var valid_579967 = query.getOrDefault("alt")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = newJString("json"))
  if valid_579967 != nil:
    section.add "alt", valid_579967
  var valid_579968 = query.getOrDefault("uploadType")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "uploadType", valid_579968
  var valid_579969 = query.getOrDefault("quotaUser")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "quotaUser", valid_579969
  var valid_579970 = query.getOrDefault("callback")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "callback", valid_579970
  var valid_579971 = query.getOrDefault("fields")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "fields", valid_579971
  var valid_579972 = query.getOrDefault("access_token")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "access_token", valid_579972
  var valid_579973 = query.getOrDefault("upload_protocol")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "upload_protocol", valid_579973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579974: Call_ContainerProjectsZonesClustersGet_579956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific cluster.
  ## 
  let valid = call_579974.validator(path, query, header, formData, body)
  let scheme = call_579974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579974.url(scheme.get, call_579974.host, call_579974.base,
                         call_579974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579974, url, valid)

proc call*(call_579975: Call_ContainerProjectsZonesClustersGet_579956;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; name: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersGet
  ## Gets the details of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project, location, cluster) of the cluster to retrieve.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to retrieve.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579976 = newJObject()
  var query_579977 = newJObject()
  add(query_579977, "key", newJString(key))
  add(query_579977, "prettyPrint", newJBool(prettyPrint))
  add(query_579977, "oauth_token", newJString(oauthToken))
  add(query_579977, "name", newJString(name))
  add(path_579976, "projectId", newJString(projectId))
  add(query_579977, "$.xgafv", newJString(Xgafv))
  add(query_579977, "alt", newJString(alt))
  add(query_579977, "uploadType", newJString(uploadType))
  add(query_579977, "quotaUser", newJString(quotaUser))
  add(path_579976, "clusterId", newJString(clusterId))
  add(path_579976, "zone", newJString(zone))
  add(query_579977, "callback", newJString(callback))
  add(query_579977, "fields", newJString(fields))
  add(query_579977, "access_token", newJString(accessToken))
  add(query_579977, "upload_protocol", newJString(uploadProtocol))
  result = call_579975.call(path_579976, query_579977, nil, nil, nil)

var containerProjectsZonesClustersGet* = Call_ContainerProjectsZonesClustersGet_579956(
    name: "containerProjectsZonesClustersGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersGet_579957, base: "/",
    url: url_ContainerProjectsZonesClustersGet_579958, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersDelete_580001 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersDelete_580003(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersDelete_580002(path: JsonNode;
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
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580004 = path.getOrDefault("projectId")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "projectId", valid_580004
  var valid_580005 = path.getOrDefault("clusterId")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "clusterId", valid_580005
  var valid_580006 = path.getOrDefault("zone")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = nil)
  if valid_580006 != nil:
    section.add "zone", valid_580006
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, cluster) of the cluster to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("prettyPrint")
  valid_580008 = validateParameter(valid_580008, JBool, required = false,
                                 default = newJBool(true))
  if valid_580008 != nil:
    section.add "prettyPrint", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("name")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "name", valid_580010
  var valid_580011 = query.getOrDefault("$.xgafv")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("1"))
  if valid_580011 != nil:
    section.add "$.xgafv", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("uploadType")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "uploadType", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("callback")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "callback", valid_580015
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("upload_protocol")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "upload_protocol", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_ContainerProjectsZonesClustersDelete_580001;
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
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_ContainerProjectsZonesClustersDelete_580001;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; name: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project, location, cluster) of the cluster to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "key", newJString(key))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "name", newJString(name))
  add(path_580021, "projectId", newJString(projectId))
  add(query_580022, "$.xgafv", newJString(Xgafv))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "uploadType", newJString(uploadType))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(path_580021, "clusterId", newJString(clusterId))
  add(path_580021, "zone", newJString(zone))
  add(query_580022, "callback", newJString(callback))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "access_token", newJString(accessToken))
  add(query_580022, "upload_protocol", newJString(uploadProtocol))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var containerProjectsZonesClustersDelete* = Call_ContainerProjectsZonesClustersDelete_580001(
    name: "containerProjectsZonesClustersDelete", meth: HttpMethod.HttpDelete,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersDelete_580002, base: "/",
    url: url_ContainerProjectsZonesClustersDelete_580003, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersAddons_580023 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersAddons_580025(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersAddons_580024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580026 = path.getOrDefault("projectId")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "projectId", valid_580026
  var valid_580027 = path.getOrDefault("clusterId")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "clusterId", valid_580027
  var valid_580028 = path.getOrDefault("zone")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "zone", valid_580028
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580029 = query.getOrDefault("key")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "key", valid_580029
  var valid_580030 = query.getOrDefault("prettyPrint")
  valid_580030 = validateParameter(valid_580030, JBool, required = false,
                                 default = newJBool(true))
  if valid_580030 != nil:
    section.add "prettyPrint", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("$.xgafv")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("1"))
  if valid_580032 != nil:
    section.add "$.xgafv", valid_580032
  var valid_580033 = query.getOrDefault("alt")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("json"))
  if valid_580033 != nil:
    section.add "alt", valid_580033
  var valid_580034 = query.getOrDefault("uploadType")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "uploadType", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("callback")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "callback", valid_580036
  var valid_580037 = query.getOrDefault("fields")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "fields", valid_580037
  var valid_580038 = query.getOrDefault("access_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "access_token", valid_580038
  var valid_580039 = query.getOrDefault("upload_protocol")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "upload_protocol", valid_580039
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

proc call*(call_580041: Call_ContainerProjectsZonesClustersAddons_580023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_ContainerProjectsZonesClustersAddons_580023;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersAddons
  ## Sets the addons for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580043 = newJObject()
  var query_580044 = newJObject()
  var body_580045 = newJObject()
  add(query_580044, "key", newJString(key))
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(path_580043, "projectId", newJString(projectId))
  add(query_580044, "$.xgafv", newJString(Xgafv))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "uploadType", newJString(uploadType))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(path_580043, "clusterId", newJString(clusterId))
  add(path_580043, "zone", newJString(zone))
  if body != nil:
    body_580045 = body
  add(query_580044, "callback", newJString(callback))
  add(query_580044, "fields", newJString(fields))
  add(query_580044, "access_token", newJString(accessToken))
  add(query_580044, "upload_protocol", newJString(uploadProtocol))
  result = call_580042.call(path_580043, query_580044, nil, nil, body_580045)

var containerProjectsZonesClustersAddons* = Call_ContainerProjectsZonesClustersAddons_580023(
    name: "containerProjectsZonesClustersAddons", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/addons",
    validator: validate_ContainerProjectsZonesClustersAddons_580024, base: "/",
    url: url_ContainerProjectsZonesClustersAddons_580025, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLegacyAbac_580046 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersLegacyAbac_580048(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersLegacyAbac_580047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580049 = path.getOrDefault("projectId")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "projectId", valid_580049
  var valid_580050 = path.getOrDefault("clusterId")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "clusterId", valid_580050
  var valid_580051 = path.getOrDefault("zone")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "zone", valid_580051
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
  var valid_580054 = query.getOrDefault("oauth_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "oauth_token", valid_580054
  var valid_580055 = query.getOrDefault("$.xgafv")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("1"))
  if valid_580055 != nil:
    section.add "$.xgafv", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("uploadType")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "uploadType", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("callback")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "callback", valid_580059
  var valid_580060 = query.getOrDefault("fields")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "fields", valid_580060
  var valid_580061 = query.getOrDefault("access_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "access_token", valid_580061
  var valid_580062 = query.getOrDefault("upload_protocol")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "upload_protocol", valid_580062
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

proc call*(call_580064: Call_ContainerProjectsZonesClustersLegacyAbac_580046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_ContainerProjectsZonesClustersLegacyAbac_580046;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  var body_580068 = newJObject()
  add(query_580067, "key", newJString(key))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(path_580066, "projectId", newJString(projectId))
  add(query_580067, "$.xgafv", newJString(Xgafv))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "uploadType", newJString(uploadType))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(path_580066, "clusterId", newJString(clusterId))
  add(path_580066, "zone", newJString(zone))
  if body != nil:
    body_580068 = body
  add(query_580067, "callback", newJString(callback))
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "access_token", newJString(accessToken))
  add(query_580067, "upload_protocol", newJString(uploadProtocol))
  result = call_580065.call(path_580066, query_580067, nil, nil, body_580068)

var containerProjectsZonesClustersLegacyAbac* = Call_ContainerProjectsZonesClustersLegacyAbac_580046(
    name: "containerProjectsZonesClustersLegacyAbac", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/legacyAbac",
    validator: validate_ContainerProjectsZonesClustersLegacyAbac_580047,
    base: "/", url: url_ContainerProjectsZonesClustersLegacyAbac_580048,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLocations_580069 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersLocations_580071(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersLocations_580070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the locations for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580072 = path.getOrDefault("projectId")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "projectId", valid_580072
  var valid_580073 = path.getOrDefault("clusterId")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "clusterId", valid_580073
  var valid_580074 = path.getOrDefault("zone")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "zone", valid_580074
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("$.xgafv")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("1"))
  if valid_580078 != nil:
    section.add "$.xgafv", valid_580078
  var valid_580079 = query.getOrDefault("alt")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("json"))
  if valid_580079 != nil:
    section.add "alt", valid_580079
  var valid_580080 = query.getOrDefault("uploadType")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "uploadType", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("callback")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "callback", valid_580082
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  var valid_580084 = query.getOrDefault("access_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "access_token", valid_580084
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
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

proc call*(call_580087: Call_ContainerProjectsZonesClustersLocations_580069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_ContainerProjectsZonesClustersLocations_580069;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersLocations
  ## Sets the locations for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580089 = newJObject()
  var query_580090 = newJObject()
  var body_580091 = newJObject()
  add(query_580090, "key", newJString(key))
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(path_580089, "projectId", newJString(projectId))
  add(query_580090, "$.xgafv", newJString(Xgafv))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "uploadType", newJString(uploadType))
  add(query_580090, "quotaUser", newJString(quotaUser))
  add(path_580089, "clusterId", newJString(clusterId))
  add(path_580089, "zone", newJString(zone))
  if body != nil:
    body_580091 = body
  add(query_580090, "callback", newJString(callback))
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "access_token", newJString(accessToken))
  add(query_580090, "upload_protocol", newJString(uploadProtocol))
  result = call_580088.call(path_580089, query_580090, nil, nil, body_580091)

var containerProjectsZonesClustersLocations* = Call_ContainerProjectsZonesClustersLocations_580069(
    name: "containerProjectsZonesClustersLocations", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/locations",
    validator: validate_ContainerProjectsZonesClustersLocations_580070, base: "/",
    url: url_ContainerProjectsZonesClustersLocations_580071,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLogging_580092 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersLogging_580094(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersLogging_580093(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580095 = path.getOrDefault("projectId")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "projectId", valid_580095
  var valid_580096 = path.getOrDefault("clusterId")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "clusterId", valid_580096
  var valid_580097 = path.getOrDefault("zone")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "zone", valid_580097
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580098 = query.getOrDefault("key")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "key", valid_580098
  var valid_580099 = query.getOrDefault("prettyPrint")
  valid_580099 = validateParameter(valid_580099, JBool, required = false,
                                 default = newJBool(true))
  if valid_580099 != nil:
    section.add "prettyPrint", valid_580099
  var valid_580100 = query.getOrDefault("oauth_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "oauth_token", valid_580100
  var valid_580101 = query.getOrDefault("$.xgafv")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("1"))
  if valid_580101 != nil:
    section.add "$.xgafv", valid_580101
  var valid_580102 = query.getOrDefault("alt")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("json"))
  if valid_580102 != nil:
    section.add "alt", valid_580102
  var valid_580103 = query.getOrDefault("uploadType")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "uploadType", valid_580103
  var valid_580104 = query.getOrDefault("quotaUser")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "quotaUser", valid_580104
  var valid_580105 = query.getOrDefault("callback")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "callback", valid_580105
  var valid_580106 = query.getOrDefault("fields")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "fields", valid_580106
  var valid_580107 = query.getOrDefault("access_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "access_token", valid_580107
  var valid_580108 = query.getOrDefault("upload_protocol")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "upload_protocol", valid_580108
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

proc call*(call_580110: Call_ContainerProjectsZonesClustersLogging_580092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_ContainerProjectsZonesClustersLogging_580092;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersLogging
  ## Sets the logging service for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580112 = newJObject()
  var query_580113 = newJObject()
  var body_580114 = newJObject()
  add(query_580113, "key", newJString(key))
  add(query_580113, "prettyPrint", newJBool(prettyPrint))
  add(query_580113, "oauth_token", newJString(oauthToken))
  add(path_580112, "projectId", newJString(projectId))
  add(query_580113, "$.xgafv", newJString(Xgafv))
  add(query_580113, "alt", newJString(alt))
  add(query_580113, "uploadType", newJString(uploadType))
  add(query_580113, "quotaUser", newJString(quotaUser))
  add(path_580112, "clusterId", newJString(clusterId))
  add(path_580112, "zone", newJString(zone))
  if body != nil:
    body_580114 = body
  add(query_580113, "callback", newJString(callback))
  add(query_580113, "fields", newJString(fields))
  add(query_580113, "access_token", newJString(accessToken))
  add(query_580113, "upload_protocol", newJString(uploadProtocol))
  result = call_580111.call(path_580112, query_580113, nil, nil, body_580114)

var containerProjectsZonesClustersLogging* = Call_ContainerProjectsZonesClustersLogging_580092(
    name: "containerProjectsZonesClustersLogging", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/logging",
    validator: validate_ContainerProjectsZonesClustersLogging_580093, base: "/",
    url: url_ContainerProjectsZonesClustersLogging_580094, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMaster_580115 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersMaster_580117(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersMaster_580116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the master for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580118 = path.getOrDefault("projectId")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "projectId", valid_580118
  var valid_580119 = path.getOrDefault("clusterId")
  valid_580119 = validateParameter(valid_580119, JString, required = true,
                                 default = nil)
  if valid_580119 != nil:
    section.add "clusterId", valid_580119
  var valid_580120 = path.getOrDefault("zone")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "zone", valid_580120
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
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
  var valid_580123 = query.getOrDefault("oauth_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "oauth_token", valid_580123
  var valid_580124 = query.getOrDefault("$.xgafv")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("1"))
  if valid_580124 != nil:
    section.add "$.xgafv", valid_580124
  var valid_580125 = query.getOrDefault("alt")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("json"))
  if valid_580125 != nil:
    section.add "alt", valid_580125
  var valid_580126 = query.getOrDefault("uploadType")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "uploadType", valid_580126
  var valid_580127 = query.getOrDefault("quotaUser")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "quotaUser", valid_580127
  var valid_580128 = query.getOrDefault("callback")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "callback", valid_580128
  var valid_580129 = query.getOrDefault("fields")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "fields", valid_580129
  var valid_580130 = query.getOrDefault("access_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "access_token", valid_580130
  var valid_580131 = query.getOrDefault("upload_protocol")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "upload_protocol", valid_580131
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

proc call*(call_580133: Call_ContainerProjectsZonesClustersMaster_580115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_ContainerProjectsZonesClustersMaster_580115;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersMaster
  ## Updates the master for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  var body_580137 = newJObject()
  add(query_580136, "key", newJString(key))
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(path_580135, "projectId", newJString(projectId))
  add(query_580136, "$.xgafv", newJString(Xgafv))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "uploadType", newJString(uploadType))
  add(query_580136, "quotaUser", newJString(quotaUser))
  add(path_580135, "clusterId", newJString(clusterId))
  add(path_580135, "zone", newJString(zone))
  if body != nil:
    body_580137 = body
  add(query_580136, "callback", newJString(callback))
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "access_token", newJString(accessToken))
  add(query_580136, "upload_protocol", newJString(uploadProtocol))
  result = call_580134.call(path_580135, query_580136, nil, nil, body_580137)

var containerProjectsZonesClustersMaster* = Call_ContainerProjectsZonesClustersMaster_580115(
    name: "containerProjectsZonesClustersMaster", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/master",
    validator: validate_ContainerProjectsZonesClustersMaster_580116, base: "/",
    url: url_ContainerProjectsZonesClustersMaster_580117, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMonitoring_580138 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersMonitoring_580140(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersMonitoring_580139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the monitoring service for a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580141 = path.getOrDefault("projectId")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "projectId", valid_580141
  var valid_580142 = path.getOrDefault("clusterId")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "clusterId", valid_580142
  var valid_580143 = path.getOrDefault("zone")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "zone", valid_580143
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580144 = query.getOrDefault("key")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "key", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
  var valid_580146 = query.getOrDefault("oauth_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "oauth_token", valid_580146
  var valid_580147 = query.getOrDefault("$.xgafv")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("1"))
  if valid_580147 != nil:
    section.add "$.xgafv", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("uploadType")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "uploadType", valid_580149
  var valid_580150 = query.getOrDefault("quotaUser")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "quotaUser", valid_580150
  var valid_580151 = query.getOrDefault("callback")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "callback", valid_580151
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("access_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "access_token", valid_580153
  var valid_580154 = query.getOrDefault("upload_protocol")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "upload_protocol", valid_580154
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

proc call*(call_580156: Call_ContainerProjectsZonesClustersMonitoring_580138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_580156.validator(path, query, header, formData, body)
  let scheme = call_580156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580156.url(scheme.get, call_580156.host, call_580156.base,
                         call_580156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580156, url, valid)

proc call*(call_580157: Call_ContainerProjectsZonesClustersMonitoring_580138;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersMonitoring
  ## Sets the monitoring service for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580158 = newJObject()
  var query_580159 = newJObject()
  var body_580160 = newJObject()
  add(query_580159, "key", newJString(key))
  add(query_580159, "prettyPrint", newJBool(prettyPrint))
  add(query_580159, "oauth_token", newJString(oauthToken))
  add(path_580158, "projectId", newJString(projectId))
  add(query_580159, "$.xgafv", newJString(Xgafv))
  add(query_580159, "alt", newJString(alt))
  add(query_580159, "uploadType", newJString(uploadType))
  add(query_580159, "quotaUser", newJString(quotaUser))
  add(path_580158, "clusterId", newJString(clusterId))
  add(path_580158, "zone", newJString(zone))
  if body != nil:
    body_580160 = body
  add(query_580159, "callback", newJString(callback))
  add(query_580159, "fields", newJString(fields))
  add(query_580159, "access_token", newJString(accessToken))
  add(query_580159, "upload_protocol", newJString(uploadProtocol))
  result = call_580157.call(path_580158, query_580159, nil, nil, body_580160)

var containerProjectsZonesClustersMonitoring* = Call_ContainerProjectsZonesClustersMonitoring_580138(
    name: "containerProjectsZonesClustersMonitoring", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/monitoring",
    validator: validate_ContainerProjectsZonesClustersMonitoring_580139,
    base: "/", url: url_ContainerProjectsZonesClustersMonitoring_580140,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsCreate_580183 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersNodePoolsCreate_580185(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsCreate_580184(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580186 = path.getOrDefault("projectId")
  valid_580186 = validateParameter(valid_580186, JString, required = true,
                                 default = nil)
  if valid_580186 != nil:
    section.add "projectId", valid_580186
  var valid_580187 = path.getOrDefault("clusterId")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "clusterId", valid_580187
  var valid_580188 = path.getOrDefault("zone")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "zone", valid_580188
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
  var valid_580191 = query.getOrDefault("oauth_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "oauth_token", valid_580191
  var valid_580192 = query.getOrDefault("$.xgafv")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("1"))
  if valid_580192 != nil:
    section.add "$.xgafv", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("uploadType")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "uploadType", valid_580194
  var valid_580195 = query.getOrDefault("quotaUser")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "quotaUser", valid_580195
  var valid_580196 = query.getOrDefault("callback")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "callback", valid_580196
  var valid_580197 = query.getOrDefault("fields")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "fields", valid_580197
  var valid_580198 = query.getOrDefault("access_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "access_token", valid_580198
  var valid_580199 = query.getOrDefault("upload_protocol")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "upload_protocol", valid_580199
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

proc call*(call_580201: Call_ContainerProjectsZonesClustersNodePoolsCreate_580183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_580201.validator(path, query, header, formData, body)
  let scheme = call_580201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580201.url(scheme.get, call_580201.host, call_580201.base,
                         call_580201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580201, url, valid)

proc call*(call_580202: Call_ContainerProjectsZonesClustersNodePoolsCreate_580183;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580203 = newJObject()
  var query_580204 = newJObject()
  var body_580205 = newJObject()
  add(query_580204, "key", newJString(key))
  add(query_580204, "prettyPrint", newJBool(prettyPrint))
  add(query_580204, "oauth_token", newJString(oauthToken))
  add(path_580203, "projectId", newJString(projectId))
  add(query_580204, "$.xgafv", newJString(Xgafv))
  add(query_580204, "alt", newJString(alt))
  add(query_580204, "uploadType", newJString(uploadType))
  add(query_580204, "quotaUser", newJString(quotaUser))
  add(path_580203, "clusterId", newJString(clusterId))
  add(path_580203, "zone", newJString(zone))
  if body != nil:
    body_580205 = body
  add(query_580204, "callback", newJString(callback))
  add(query_580204, "fields", newJString(fields))
  add(query_580204, "access_token", newJString(accessToken))
  add(query_580204, "upload_protocol", newJString(uploadProtocol))
  result = call_580202.call(path_580203, query_580204, nil, nil, body_580205)

var containerProjectsZonesClustersNodePoolsCreate* = Call_ContainerProjectsZonesClustersNodePoolsCreate_580183(
    name: "containerProjectsZonesClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsCreate_580184,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsCreate_580185,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsList_580161 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersNodePoolsList_580163(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsList_580162(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580164 = path.getOrDefault("projectId")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "projectId", valid_580164
  var valid_580165 = path.getOrDefault("clusterId")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "clusterId", valid_580165
  var valid_580166 = path.getOrDefault("zone")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "zone", valid_580166
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("prettyPrint")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "prettyPrint", valid_580168
  var valid_580169 = query.getOrDefault("oauth_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "oauth_token", valid_580169
  var valid_580170 = query.getOrDefault("$.xgafv")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("1"))
  if valid_580170 != nil:
    section.add "$.xgafv", valid_580170
  var valid_580171 = query.getOrDefault("alt")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("json"))
  if valid_580171 != nil:
    section.add "alt", valid_580171
  var valid_580172 = query.getOrDefault("uploadType")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "uploadType", valid_580172
  var valid_580173 = query.getOrDefault("parent")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "parent", valid_580173
  var valid_580174 = query.getOrDefault("quotaUser")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "quotaUser", valid_580174
  var valid_580175 = query.getOrDefault("callback")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "callback", valid_580175
  var valid_580176 = query.getOrDefault("fields")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "fields", valid_580176
  var valid_580177 = query.getOrDefault("access_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "access_token", valid_580177
  var valid_580178 = query.getOrDefault("upload_protocol")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "upload_protocol", valid_580178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580179: Call_ContainerProjectsZonesClustersNodePoolsList_580161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_ContainerProjectsZonesClustersNodePoolsList_580161;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; parent: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  add(query_580182, "key", newJString(key))
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(path_580181, "projectId", newJString(projectId))
  add(query_580182, "$.xgafv", newJString(Xgafv))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "uploadType", newJString(uploadType))
  add(query_580182, "parent", newJString(parent))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(path_580181, "clusterId", newJString(clusterId))
  add(path_580181, "zone", newJString(zone))
  add(query_580182, "callback", newJString(callback))
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "access_token", newJString(accessToken))
  add(query_580182, "upload_protocol", newJString(uploadProtocol))
  result = call_580180.call(path_580181, query_580182, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsList* = Call_ContainerProjectsZonesClustersNodePoolsList_580161(
    name: "containerProjectsZonesClustersNodePoolsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsList_580162,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsList_580163,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsGet_580206 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersNodePoolsGet_580208(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsGet_580207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the requested node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580209 = path.getOrDefault("projectId")
  valid_580209 = validateParameter(valid_580209, JString, required = true,
                                 default = nil)
  if valid_580209 != nil:
    section.add "projectId", valid_580209
  var valid_580210 = path.getOrDefault("clusterId")
  valid_580210 = validateParameter(valid_580210, JString, required = true,
                                 default = nil)
  if valid_580210 != nil:
    section.add "clusterId", valid_580210
  var valid_580211 = path.getOrDefault("nodePoolId")
  valid_580211 = validateParameter(valid_580211, JString, required = true,
                                 default = nil)
  if valid_580211 != nil:
    section.add "nodePoolId", valid_580211
  var valid_580212 = path.getOrDefault("zone")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "zone", valid_580212
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580213 = query.getOrDefault("key")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "key", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
  var valid_580215 = query.getOrDefault("oauth_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "oauth_token", valid_580215
  var valid_580216 = query.getOrDefault("name")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "name", valid_580216
  var valid_580217 = query.getOrDefault("$.xgafv")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("1"))
  if valid_580217 != nil:
    section.add "$.xgafv", valid_580217
  var valid_580218 = query.getOrDefault("alt")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("json"))
  if valid_580218 != nil:
    section.add "alt", valid_580218
  var valid_580219 = query.getOrDefault("uploadType")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "uploadType", valid_580219
  var valid_580220 = query.getOrDefault("quotaUser")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "quotaUser", valid_580220
  var valid_580221 = query.getOrDefault("callback")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "callback", valid_580221
  var valid_580222 = query.getOrDefault("fields")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "fields", valid_580222
  var valid_580223 = query.getOrDefault("access_token")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "access_token", valid_580223
  var valid_580224 = query.getOrDefault("upload_protocol")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "upload_protocol", valid_580224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580225: Call_ContainerProjectsZonesClustersNodePoolsGet_580206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_580225.validator(path, query, header, formData, body)
  let scheme = call_580225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580225.url(scheme.get, call_580225.host, call_580225.base,
                         call_580225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580225, url, valid)

proc call*(call_580226: Call_ContainerProjectsZonesClustersNodePoolsGet_580206;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsGet
  ## Retrieves the requested node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580227 = newJObject()
  var query_580228 = newJObject()
  add(query_580228, "key", newJString(key))
  add(query_580228, "prettyPrint", newJBool(prettyPrint))
  add(query_580228, "oauth_token", newJString(oauthToken))
  add(query_580228, "name", newJString(name))
  add(path_580227, "projectId", newJString(projectId))
  add(query_580228, "$.xgafv", newJString(Xgafv))
  add(query_580228, "alt", newJString(alt))
  add(query_580228, "uploadType", newJString(uploadType))
  add(query_580228, "quotaUser", newJString(quotaUser))
  add(path_580227, "clusterId", newJString(clusterId))
  add(path_580227, "nodePoolId", newJString(nodePoolId))
  add(path_580227, "zone", newJString(zone))
  add(query_580228, "callback", newJString(callback))
  add(query_580228, "fields", newJString(fields))
  add(query_580228, "access_token", newJString(accessToken))
  add(query_580228, "upload_protocol", newJString(uploadProtocol))
  result = call_580226.call(path_580227, query_580228, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsGet* = Call_ContainerProjectsZonesClustersNodePoolsGet_580206(
    name: "containerProjectsZonesClustersNodePoolsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsGet_580207,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsGet_580208,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsDelete_580229 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersNodePoolsDelete_580231(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsDelete_580230(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580232 = path.getOrDefault("projectId")
  valid_580232 = validateParameter(valid_580232, JString, required = true,
                                 default = nil)
  if valid_580232 != nil:
    section.add "projectId", valid_580232
  var valid_580233 = path.getOrDefault("clusterId")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "clusterId", valid_580233
  var valid_580234 = path.getOrDefault("nodePoolId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "nodePoolId", valid_580234
  var valid_580235 = path.getOrDefault("zone")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "zone", valid_580235
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580236 = query.getOrDefault("key")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "key", valid_580236
  var valid_580237 = query.getOrDefault("prettyPrint")
  valid_580237 = validateParameter(valid_580237, JBool, required = false,
                                 default = newJBool(true))
  if valid_580237 != nil:
    section.add "prettyPrint", valid_580237
  var valid_580238 = query.getOrDefault("oauth_token")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "oauth_token", valid_580238
  var valid_580239 = query.getOrDefault("name")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "name", valid_580239
  var valid_580240 = query.getOrDefault("$.xgafv")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("1"))
  if valid_580240 != nil:
    section.add "$.xgafv", valid_580240
  var valid_580241 = query.getOrDefault("alt")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = newJString("json"))
  if valid_580241 != nil:
    section.add "alt", valid_580241
  var valid_580242 = query.getOrDefault("uploadType")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "uploadType", valid_580242
  var valid_580243 = query.getOrDefault("quotaUser")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "quotaUser", valid_580243
  var valid_580244 = query.getOrDefault("callback")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "callback", valid_580244
  var valid_580245 = query.getOrDefault("fields")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "fields", valid_580245
  var valid_580246 = query.getOrDefault("access_token")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "access_token", valid_580246
  var valid_580247 = query.getOrDefault("upload_protocol")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "upload_protocol", valid_580247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580248: Call_ContainerProjectsZonesClustersNodePoolsDelete_580229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_580248.validator(path, query, header, formData, body)
  let scheme = call_580248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580248.url(scheme.get, call_580248.host, call_580248.base,
                         call_580248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580248, url, valid)

proc call*(call_580249: Call_ContainerProjectsZonesClustersNodePoolsDelete_580229;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580250 = newJObject()
  var query_580251 = newJObject()
  add(query_580251, "key", newJString(key))
  add(query_580251, "prettyPrint", newJBool(prettyPrint))
  add(query_580251, "oauth_token", newJString(oauthToken))
  add(query_580251, "name", newJString(name))
  add(path_580250, "projectId", newJString(projectId))
  add(query_580251, "$.xgafv", newJString(Xgafv))
  add(query_580251, "alt", newJString(alt))
  add(query_580251, "uploadType", newJString(uploadType))
  add(query_580251, "quotaUser", newJString(quotaUser))
  add(path_580250, "clusterId", newJString(clusterId))
  add(path_580250, "nodePoolId", newJString(nodePoolId))
  add(path_580250, "zone", newJString(zone))
  add(query_580251, "callback", newJString(callback))
  add(query_580251, "fields", newJString(fields))
  add(query_580251, "access_token", newJString(accessToken))
  add(query_580251, "upload_protocol", newJString(uploadProtocol))
  result = call_580249.call(path_580250, query_580251, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsDelete* = Call_ContainerProjectsZonesClustersNodePoolsDelete_580229(
    name: "containerProjectsZonesClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsDelete_580230,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsDelete_580231,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580252 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersNodePoolsAutoscaling_580254(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_580253(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580255 = path.getOrDefault("projectId")
  valid_580255 = validateParameter(valid_580255, JString, required = true,
                                 default = nil)
  if valid_580255 != nil:
    section.add "projectId", valid_580255
  var valid_580256 = path.getOrDefault("clusterId")
  valid_580256 = validateParameter(valid_580256, JString, required = true,
                                 default = nil)
  if valid_580256 != nil:
    section.add "clusterId", valid_580256
  var valid_580257 = path.getOrDefault("nodePoolId")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "nodePoolId", valid_580257
  var valid_580258 = path.getOrDefault("zone")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "zone", valid_580258
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580259 = query.getOrDefault("key")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "key", valid_580259
  var valid_580260 = query.getOrDefault("prettyPrint")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(true))
  if valid_580260 != nil:
    section.add "prettyPrint", valid_580260
  var valid_580261 = query.getOrDefault("oauth_token")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "oauth_token", valid_580261
  var valid_580262 = query.getOrDefault("$.xgafv")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = newJString("1"))
  if valid_580262 != nil:
    section.add "$.xgafv", valid_580262
  var valid_580263 = query.getOrDefault("alt")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("json"))
  if valid_580263 != nil:
    section.add "alt", valid_580263
  var valid_580264 = query.getOrDefault("uploadType")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "uploadType", valid_580264
  var valid_580265 = query.getOrDefault("quotaUser")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "quotaUser", valid_580265
  var valid_580266 = query.getOrDefault("callback")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "callback", valid_580266
  var valid_580267 = query.getOrDefault("fields")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fields", valid_580267
  var valid_580268 = query.getOrDefault("access_token")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "access_token", valid_580268
  var valid_580269 = query.getOrDefault("upload_protocol")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "upload_protocol", valid_580269
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

proc call*(call_580271: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_580271.validator(path, query, header, formData, body)
  let scheme = call_580271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580271.url(scheme.get, call_580271.host, call_580271.base,
                         call_580271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580271, url, valid)

proc call*(call_580272: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580252;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsAutoscaling
  ## Sets the autoscaling settings for the specified node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580273 = newJObject()
  var query_580274 = newJObject()
  var body_580275 = newJObject()
  add(query_580274, "key", newJString(key))
  add(query_580274, "prettyPrint", newJBool(prettyPrint))
  add(query_580274, "oauth_token", newJString(oauthToken))
  add(path_580273, "projectId", newJString(projectId))
  add(query_580274, "$.xgafv", newJString(Xgafv))
  add(query_580274, "alt", newJString(alt))
  add(query_580274, "uploadType", newJString(uploadType))
  add(query_580274, "quotaUser", newJString(quotaUser))
  add(path_580273, "clusterId", newJString(clusterId))
  add(path_580273, "nodePoolId", newJString(nodePoolId))
  add(path_580273, "zone", newJString(zone))
  if body != nil:
    body_580275 = body
  add(query_580274, "callback", newJString(callback))
  add(query_580274, "fields", newJString(fields))
  add(query_580274, "access_token", newJString(accessToken))
  add(query_580274, "upload_protocol", newJString(uploadProtocol))
  result = call_580272.call(path_580273, query_580274, nil, nil, body_580275)

var containerProjectsZonesClustersNodePoolsAutoscaling* = Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580252(
    name: "containerProjectsZonesClustersNodePoolsAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/autoscaling",
    validator: validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_580253,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsAutoscaling_580254,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580276 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersNodePoolsSetManagement_580278(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsSetManagement_580277(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the NodeManagement options for a node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580279 = path.getOrDefault("projectId")
  valid_580279 = validateParameter(valid_580279, JString, required = true,
                                 default = nil)
  if valid_580279 != nil:
    section.add "projectId", valid_580279
  var valid_580280 = path.getOrDefault("clusterId")
  valid_580280 = validateParameter(valid_580280, JString, required = true,
                                 default = nil)
  if valid_580280 != nil:
    section.add "clusterId", valid_580280
  var valid_580281 = path.getOrDefault("nodePoolId")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "nodePoolId", valid_580281
  var valid_580282 = path.getOrDefault("zone")
  valid_580282 = validateParameter(valid_580282, JString, required = true,
                                 default = nil)
  if valid_580282 != nil:
    section.add "zone", valid_580282
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580283 = query.getOrDefault("key")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "key", valid_580283
  var valid_580284 = query.getOrDefault("prettyPrint")
  valid_580284 = validateParameter(valid_580284, JBool, required = false,
                                 default = newJBool(true))
  if valid_580284 != nil:
    section.add "prettyPrint", valid_580284
  var valid_580285 = query.getOrDefault("oauth_token")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "oauth_token", valid_580285
  var valid_580286 = query.getOrDefault("$.xgafv")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = newJString("1"))
  if valid_580286 != nil:
    section.add "$.xgafv", valid_580286
  var valid_580287 = query.getOrDefault("alt")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = newJString("json"))
  if valid_580287 != nil:
    section.add "alt", valid_580287
  var valid_580288 = query.getOrDefault("uploadType")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "uploadType", valid_580288
  var valid_580289 = query.getOrDefault("quotaUser")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "quotaUser", valid_580289
  var valid_580290 = query.getOrDefault("callback")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "callback", valid_580290
  var valid_580291 = query.getOrDefault("fields")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "fields", valid_580291
  var valid_580292 = query.getOrDefault("access_token")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "access_token", valid_580292
  var valid_580293 = query.getOrDefault("upload_protocol")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "upload_protocol", valid_580293
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

proc call*(call_580295: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_580295.validator(path, query, header, formData, body)
  let scheme = call_580295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580295.url(scheme.get, call_580295.host, call_580295.base,
                         call_580295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580295, url, valid)

proc call*(call_580296: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580276;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580297 = newJObject()
  var query_580298 = newJObject()
  var body_580299 = newJObject()
  add(query_580298, "key", newJString(key))
  add(query_580298, "prettyPrint", newJBool(prettyPrint))
  add(query_580298, "oauth_token", newJString(oauthToken))
  add(path_580297, "projectId", newJString(projectId))
  add(query_580298, "$.xgafv", newJString(Xgafv))
  add(query_580298, "alt", newJString(alt))
  add(query_580298, "uploadType", newJString(uploadType))
  add(query_580298, "quotaUser", newJString(quotaUser))
  add(path_580297, "clusterId", newJString(clusterId))
  add(path_580297, "nodePoolId", newJString(nodePoolId))
  add(path_580297, "zone", newJString(zone))
  if body != nil:
    body_580299 = body
  add(query_580298, "callback", newJString(callback))
  add(query_580298, "fields", newJString(fields))
  add(query_580298, "access_token", newJString(accessToken))
  add(query_580298, "upload_protocol", newJString(uploadProtocol))
  result = call_580296.call(path_580297, query_580298, nil, nil, body_580299)

var containerProjectsZonesClustersNodePoolsSetManagement* = Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580276(
    name: "containerProjectsZonesClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setManagement",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetManagement_580277,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetManagement_580278,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetSize_580300 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersNodePoolsSetSize_580302(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsSetSize_580301(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the size for a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580303 = path.getOrDefault("projectId")
  valid_580303 = validateParameter(valid_580303, JString, required = true,
                                 default = nil)
  if valid_580303 != nil:
    section.add "projectId", valid_580303
  var valid_580304 = path.getOrDefault("clusterId")
  valid_580304 = validateParameter(valid_580304, JString, required = true,
                                 default = nil)
  if valid_580304 != nil:
    section.add "clusterId", valid_580304
  var valid_580305 = path.getOrDefault("nodePoolId")
  valid_580305 = validateParameter(valid_580305, JString, required = true,
                                 default = nil)
  if valid_580305 != nil:
    section.add "nodePoolId", valid_580305
  var valid_580306 = path.getOrDefault("zone")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "zone", valid_580306
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580307 = query.getOrDefault("key")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "key", valid_580307
  var valid_580308 = query.getOrDefault("prettyPrint")
  valid_580308 = validateParameter(valid_580308, JBool, required = false,
                                 default = newJBool(true))
  if valid_580308 != nil:
    section.add "prettyPrint", valid_580308
  var valid_580309 = query.getOrDefault("oauth_token")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "oauth_token", valid_580309
  var valid_580310 = query.getOrDefault("$.xgafv")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("1"))
  if valid_580310 != nil:
    section.add "$.xgafv", valid_580310
  var valid_580311 = query.getOrDefault("alt")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = newJString("json"))
  if valid_580311 != nil:
    section.add "alt", valid_580311
  var valid_580312 = query.getOrDefault("uploadType")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "uploadType", valid_580312
  var valid_580313 = query.getOrDefault("quotaUser")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "quotaUser", valid_580313
  var valid_580314 = query.getOrDefault("callback")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "callback", valid_580314
  var valid_580315 = query.getOrDefault("fields")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "fields", valid_580315
  var valid_580316 = query.getOrDefault("access_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "access_token", valid_580316
  var valid_580317 = query.getOrDefault("upload_protocol")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "upload_protocol", valid_580317
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

proc call*(call_580319: Call_ContainerProjectsZonesClustersNodePoolsSetSize_580300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_580319.validator(path, query, header, formData, body)
  let scheme = call_580319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580319.url(scheme.get, call_580319.host, call_580319.base,
                         call_580319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580319, url, valid)

proc call*(call_580320: Call_ContainerProjectsZonesClustersNodePoolsSetSize_580300;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsSetSize
  ## Sets the size for a specific node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to update.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to update.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580321 = newJObject()
  var query_580322 = newJObject()
  var body_580323 = newJObject()
  add(query_580322, "key", newJString(key))
  add(query_580322, "prettyPrint", newJBool(prettyPrint))
  add(query_580322, "oauth_token", newJString(oauthToken))
  add(path_580321, "projectId", newJString(projectId))
  add(query_580322, "$.xgafv", newJString(Xgafv))
  add(query_580322, "alt", newJString(alt))
  add(query_580322, "uploadType", newJString(uploadType))
  add(query_580322, "quotaUser", newJString(quotaUser))
  add(path_580321, "clusterId", newJString(clusterId))
  add(path_580321, "nodePoolId", newJString(nodePoolId))
  add(path_580321, "zone", newJString(zone))
  if body != nil:
    body_580323 = body
  add(query_580322, "callback", newJString(callback))
  add(query_580322, "fields", newJString(fields))
  add(query_580322, "access_token", newJString(accessToken))
  add(query_580322, "upload_protocol", newJString(uploadProtocol))
  result = call_580320.call(path_580321, query_580322, nil, nil, body_580323)

var containerProjectsZonesClustersNodePoolsSetSize* = Call_ContainerProjectsZonesClustersNodePoolsSetSize_580300(
    name: "containerProjectsZonesClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setSize",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetSize_580301,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetSize_580302,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsUpdate_580324 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersNodePoolsUpdate_580326(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsUpdate_580325(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580327 = path.getOrDefault("projectId")
  valid_580327 = validateParameter(valid_580327, JString, required = true,
                                 default = nil)
  if valid_580327 != nil:
    section.add "projectId", valid_580327
  var valid_580328 = path.getOrDefault("clusterId")
  valid_580328 = validateParameter(valid_580328, JString, required = true,
                                 default = nil)
  if valid_580328 != nil:
    section.add "clusterId", valid_580328
  var valid_580329 = path.getOrDefault("nodePoolId")
  valid_580329 = validateParameter(valid_580329, JString, required = true,
                                 default = nil)
  if valid_580329 != nil:
    section.add "nodePoolId", valid_580329
  var valid_580330 = path.getOrDefault("zone")
  valid_580330 = validateParameter(valid_580330, JString, required = true,
                                 default = nil)
  if valid_580330 != nil:
    section.add "zone", valid_580330
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("prettyPrint")
  valid_580332 = validateParameter(valid_580332, JBool, required = false,
                                 default = newJBool(true))
  if valid_580332 != nil:
    section.add "prettyPrint", valid_580332
  var valid_580333 = query.getOrDefault("oauth_token")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "oauth_token", valid_580333
  var valid_580334 = query.getOrDefault("$.xgafv")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = newJString("1"))
  if valid_580334 != nil:
    section.add "$.xgafv", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("uploadType")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "uploadType", valid_580336
  var valid_580337 = query.getOrDefault("quotaUser")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "quotaUser", valid_580337
  var valid_580338 = query.getOrDefault("callback")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "callback", valid_580338
  var valid_580339 = query.getOrDefault("fields")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "fields", valid_580339
  var valid_580340 = query.getOrDefault("access_token")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "access_token", valid_580340
  var valid_580341 = query.getOrDefault("upload_protocol")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "upload_protocol", valid_580341
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

proc call*(call_580343: Call_ContainerProjectsZonesClustersNodePoolsUpdate_580324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_580343.validator(path, query, header, formData, body)
  let scheme = call_580343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580343.url(scheme.get, call_580343.host, call_580343.base,
                         call_580343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580343, url, valid)

proc call*(call_580344: Call_ContainerProjectsZonesClustersNodePoolsUpdate_580324;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsUpdate
  ## Updates the version and/or image type for the specified node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580345 = newJObject()
  var query_580346 = newJObject()
  var body_580347 = newJObject()
  add(query_580346, "key", newJString(key))
  add(query_580346, "prettyPrint", newJBool(prettyPrint))
  add(query_580346, "oauth_token", newJString(oauthToken))
  add(path_580345, "projectId", newJString(projectId))
  add(query_580346, "$.xgafv", newJString(Xgafv))
  add(query_580346, "alt", newJString(alt))
  add(query_580346, "uploadType", newJString(uploadType))
  add(query_580346, "quotaUser", newJString(quotaUser))
  add(path_580345, "clusterId", newJString(clusterId))
  add(path_580345, "nodePoolId", newJString(nodePoolId))
  add(path_580345, "zone", newJString(zone))
  if body != nil:
    body_580347 = body
  add(query_580346, "callback", newJString(callback))
  add(query_580346, "fields", newJString(fields))
  add(query_580346, "access_token", newJString(accessToken))
  add(query_580346, "upload_protocol", newJString(uploadProtocol))
  result = call_580344.call(path_580345, query_580346, nil, nil, body_580347)

var containerProjectsZonesClustersNodePoolsUpdate* = Call_ContainerProjectsZonesClustersNodePoolsUpdate_580324(
    name: "containerProjectsZonesClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/update",
    validator: validate_ContainerProjectsZonesClustersNodePoolsUpdate_580325,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsUpdate_580326,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsRollback_580348 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersNodePoolsRollback_580350(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersNodePoolsRollback_580349(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to rollback.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: JString (required)
  ##             : Deprecated. The name of the node pool to rollback.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580351 = path.getOrDefault("projectId")
  valid_580351 = validateParameter(valid_580351, JString, required = true,
                                 default = nil)
  if valid_580351 != nil:
    section.add "projectId", valid_580351
  var valid_580352 = path.getOrDefault("clusterId")
  valid_580352 = validateParameter(valid_580352, JString, required = true,
                                 default = nil)
  if valid_580352 != nil:
    section.add "clusterId", valid_580352
  var valid_580353 = path.getOrDefault("nodePoolId")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "nodePoolId", valid_580353
  var valid_580354 = path.getOrDefault("zone")
  valid_580354 = validateParameter(valid_580354, JString, required = true,
                                 default = nil)
  if valid_580354 != nil:
    section.add "zone", valid_580354
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580355 = query.getOrDefault("key")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "key", valid_580355
  var valid_580356 = query.getOrDefault("prettyPrint")
  valid_580356 = validateParameter(valid_580356, JBool, required = false,
                                 default = newJBool(true))
  if valid_580356 != nil:
    section.add "prettyPrint", valid_580356
  var valid_580357 = query.getOrDefault("oauth_token")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "oauth_token", valid_580357
  var valid_580358 = query.getOrDefault("$.xgafv")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = newJString("1"))
  if valid_580358 != nil:
    section.add "$.xgafv", valid_580358
  var valid_580359 = query.getOrDefault("alt")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("json"))
  if valid_580359 != nil:
    section.add "alt", valid_580359
  var valid_580360 = query.getOrDefault("uploadType")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "uploadType", valid_580360
  var valid_580361 = query.getOrDefault("quotaUser")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "quotaUser", valid_580361
  var valid_580362 = query.getOrDefault("callback")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "callback", valid_580362
  var valid_580363 = query.getOrDefault("fields")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "fields", valid_580363
  var valid_580364 = query.getOrDefault("access_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "access_token", valid_580364
  var valid_580365 = query.getOrDefault("upload_protocol")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "upload_protocol", valid_580365
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

proc call*(call_580367: Call_ContainerProjectsZonesClustersNodePoolsRollback_580348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_580367.validator(path, query, header, formData, body)
  let scheme = call_580367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580367.url(scheme.get, call_580367.host, call_580367.base,
                         call_580367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580367, url, valid)

proc call*(call_580368: Call_ContainerProjectsZonesClustersNodePoolsRollback_580348;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsRollback
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to rollback.
  ## This field has been deprecated and replaced by the name field.
  ##   nodePoolId: string (required)
  ##             : Deprecated. The name of the node pool to rollback.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580369 = newJObject()
  var query_580370 = newJObject()
  var body_580371 = newJObject()
  add(query_580370, "key", newJString(key))
  add(query_580370, "prettyPrint", newJBool(prettyPrint))
  add(query_580370, "oauth_token", newJString(oauthToken))
  add(path_580369, "projectId", newJString(projectId))
  add(query_580370, "$.xgafv", newJString(Xgafv))
  add(query_580370, "alt", newJString(alt))
  add(query_580370, "uploadType", newJString(uploadType))
  add(query_580370, "quotaUser", newJString(quotaUser))
  add(path_580369, "clusterId", newJString(clusterId))
  add(path_580369, "nodePoolId", newJString(nodePoolId))
  add(path_580369, "zone", newJString(zone))
  if body != nil:
    body_580371 = body
  add(query_580370, "callback", newJString(callback))
  add(query_580370, "fields", newJString(fields))
  add(query_580370, "access_token", newJString(accessToken))
  add(query_580370, "upload_protocol", newJString(uploadProtocol))
  result = call_580368.call(path_580369, query_580370, nil, nil, body_580371)

var containerProjectsZonesClustersNodePoolsRollback* = Call_ContainerProjectsZonesClustersNodePoolsRollback_580348(
    name: "containerProjectsZonesClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}:rollback",
    validator: validate_ContainerProjectsZonesClustersNodePoolsRollback_580349,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsRollback_580350,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersResourceLabels_580372 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersResourceLabels_580374(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersResourceLabels_580373(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets labels on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580375 = path.getOrDefault("projectId")
  valid_580375 = validateParameter(valid_580375, JString, required = true,
                                 default = nil)
  if valid_580375 != nil:
    section.add "projectId", valid_580375
  var valid_580376 = path.getOrDefault("clusterId")
  valid_580376 = validateParameter(valid_580376, JString, required = true,
                                 default = nil)
  if valid_580376 != nil:
    section.add "clusterId", valid_580376
  var valid_580377 = path.getOrDefault("zone")
  valid_580377 = validateParameter(valid_580377, JString, required = true,
                                 default = nil)
  if valid_580377 != nil:
    section.add "zone", valid_580377
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580378 = query.getOrDefault("key")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "key", valid_580378
  var valid_580379 = query.getOrDefault("prettyPrint")
  valid_580379 = validateParameter(valid_580379, JBool, required = false,
                                 default = newJBool(true))
  if valid_580379 != nil:
    section.add "prettyPrint", valid_580379
  var valid_580380 = query.getOrDefault("oauth_token")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "oauth_token", valid_580380
  var valid_580381 = query.getOrDefault("$.xgafv")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = newJString("1"))
  if valid_580381 != nil:
    section.add "$.xgafv", valid_580381
  var valid_580382 = query.getOrDefault("alt")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = newJString("json"))
  if valid_580382 != nil:
    section.add "alt", valid_580382
  var valid_580383 = query.getOrDefault("uploadType")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "uploadType", valid_580383
  var valid_580384 = query.getOrDefault("quotaUser")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "quotaUser", valid_580384
  var valid_580385 = query.getOrDefault("callback")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "callback", valid_580385
  var valid_580386 = query.getOrDefault("fields")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "fields", valid_580386
  var valid_580387 = query.getOrDefault("access_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "access_token", valid_580387
  var valid_580388 = query.getOrDefault("upload_protocol")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "upload_protocol", valid_580388
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

proc call*(call_580390: Call_ContainerProjectsZonesClustersResourceLabels_580372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_580390.validator(path, query, header, formData, body)
  let scheme = call_580390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580390.url(scheme.get, call_580390.host, call_580390.base,
                         call_580390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580390, url, valid)

proc call*(call_580391: Call_ContainerProjectsZonesClustersResourceLabels_580372;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersResourceLabels
  ## Sets labels on a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580392 = newJObject()
  var query_580393 = newJObject()
  var body_580394 = newJObject()
  add(query_580393, "key", newJString(key))
  add(query_580393, "prettyPrint", newJBool(prettyPrint))
  add(query_580393, "oauth_token", newJString(oauthToken))
  add(path_580392, "projectId", newJString(projectId))
  add(query_580393, "$.xgafv", newJString(Xgafv))
  add(query_580393, "alt", newJString(alt))
  add(query_580393, "uploadType", newJString(uploadType))
  add(query_580393, "quotaUser", newJString(quotaUser))
  add(path_580392, "clusterId", newJString(clusterId))
  add(path_580392, "zone", newJString(zone))
  if body != nil:
    body_580394 = body
  add(query_580393, "callback", newJString(callback))
  add(query_580393, "fields", newJString(fields))
  add(query_580393, "access_token", newJString(accessToken))
  add(query_580393, "upload_protocol", newJString(uploadProtocol))
  result = call_580391.call(path_580392, query_580393, nil, nil, body_580394)

var containerProjectsZonesClustersResourceLabels* = Call_ContainerProjectsZonesClustersResourceLabels_580372(
    name: "containerProjectsZonesClustersResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/resourceLabels",
    validator: validate_ContainerProjectsZonesClustersResourceLabels_580373,
    base: "/", url: url_ContainerProjectsZonesClustersResourceLabels_580374,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersCompleteIpRotation_580395 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersCompleteIpRotation_580397(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersCompleteIpRotation_580396(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580398 = path.getOrDefault("projectId")
  valid_580398 = validateParameter(valid_580398, JString, required = true,
                                 default = nil)
  if valid_580398 != nil:
    section.add "projectId", valid_580398
  var valid_580399 = path.getOrDefault("clusterId")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "clusterId", valid_580399
  var valid_580400 = path.getOrDefault("zone")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "zone", valid_580400
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580401 = query.getOrDefault("key")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "key", valid_580401
  var valid_580402 = query.getOrDefault("prettyPrint")
  valid_580402 = validateParameter(valid_580402, JBool, required = false,
                                 default = newJBool(true))
  if valid_580402 != nil:
    section.add "prettyPrint", valid_580402
  var valid_580403 = query.getOrDefault("oauth_token")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "oauth_token", valid_580403
  var valid_580404 = query.getOrDefault("$.xgafv")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = newJString("1"))
  if valid_580404 != nil:
    section.add "$.xgafv", valid_580404
  var valid_580405 = query.getOrDefault("alt")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("json"))
  if valid_580405 != nil:
    section.add "alt", valid_580405
  var valid_580406 = query.getOrDefault("uploadType")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "uploadType", valid_580406
  var valid_580407 = query.getOrDefault("quotaUser")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "quotaUser", valid_580407
  var valid_580408 = query.getOrDefault("callback")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "callback", valid_580408
  var valid_580409 = query.getOrDefault("fields")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "fields", valid_580409
  var valid_580410 = query.getOrDefault("access_token")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "access_token", valid_580410
  var valid_580411 = query.getOrDefault("upload_protocol")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "upload_protocol", valid_580411
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

proc call*(call_580413: Call_ContainerProjectsZonesClustersCompleteIpRotation_580395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_580413.validator(path, query, header, formData, body)
  let scheme = call_580413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580413.url(scheme.get, call_580413.host, call_580413.base,
                         call_580413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580413, url, valid)

proc call*(call_580414: Call_ContainerProjectsZonesClustersCompleteIpRotation_580395;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580415 = newJObject()
  var query_580416 = newJObject()
  var body_580417 = newJObject()
  add(query_580416, "key", newJString(key))
  add(query_580416, "prettyPrint", newJBool(prettyPrint))
  add(query_580416, "oauth_token", newJString(oauthToken))
  add(path_580415, "projectId", newJString(projectId))
  add(query_580416, "$.xgafv", newJString(Xgafv))
  add(query_580416, "alt", newJString(alt))
  add(query_580416, "uploadType", newJString(uploadType))
  add(query_580416, "quotaUser", newJString(quotaUser))
  add(path_580415, "clusterId", newJString(clusterId))
  add(path_580415, "zone", newJString(zone))
  if body != nil:
    body_580417 = body
  add(query_580416, "callback", newJString(callback))
  add(query_580416, "fields", newJString(fields))
  add(query_580416, "access_token", newJString(accessToken))
  add(query_580416, "upload_protocol", newJString(uploadProtocol))
  result = call_580414.call(path_580415, query_580416, nil, nil, body_580417)

var containerProjectsZonesClustersCompleteIpRotation* = Call_ContainerProjectsZonesClustersCompleteIpRotation_580395(
    name: "containerProjectsZonesClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:completeIpRotation",
    validator: validate_ContainerProjectsZonesClustersCompleteIpRotation_580396,
    base: "/", url: url_ContainerProjectsZonesClustersCompleteIpRotation_580397,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580418 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersSetMaintenancePolicy_580420(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersSetMaintenancePolicy_580419(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the maintenance policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   clusterId: JString (required)
  ##            : The name of the cluster to update.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580421 = path.getOrDefault("projectId")
  valid_580421 = validateParameter(valid_580421, JString, required = true,
                                 default = nil)
  if valid_580421 != nil:
    section.add "projectId", valid_580421
  var valid_580422 = path.getOrDefault("clusterId")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "clusterId", valid_580422
  var valid_580423 = path.getOrDefault("zone")
  valid_580423 = validateParameter(valid_580423, JString, required = true,
                                 default = nil)
  if valid_580423 != nil:
    section.add "zone", valid_580423
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580424 = query.getOrDefault("key")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "key", valid_580424
  var valid_580425 = query.getOrDefault("prettyPrint")
  valid_580425 = validateParameter(valid_580425, JBool, required = false,
                                 default = newJBool(true))
  if valid_580425 != nil:
    section.add "prettyPrint", valid_580425
  var valid_580426 = query.getOrDefault("oauth_token")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "oauth_token", valid_580426
  var valid_580427 = query.getOrDefault("$.xgafv")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = newJString("1"))
  if valid_580427 != nil:
    section.add "$.xgafv", valid_580427
  var valid_580428 = query.getOrDefault("alt")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = newJString("json"))
  if valid_580428 != nil:
    section.add "alt", valid_580428
  var valid_580429 = query.getOrDefault("uploadType")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "uploadType", valid_580429
  var valid_580430 = query.getOrDefault("quotaUser")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "quotaUser", valid_580430
  var valid_580431 = query.getOrDefault("callback")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "callback", valid_580431
  var valid_580432 = query.getOrDefault("fields")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "fields", valid_580432
  var valid_580433 = query.getOrDefault("access_token")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "access_token", valid_580433
  var valid_580434 = query.getOrDefault("upload_protocol")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "upload_protocol", valid_580434
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

proc call*(call_580436: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_580436.validator(path, query, header, formData, body)
  let scheme = call_580436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580436.url(scheme.get, call_580436.host, call_580436.base,
                         call_580436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580436, url, valid)

proc call*(call_580437: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580418;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersSetMaintenancePolicy
  ## Sets the maintenance policy for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to update.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580438 = newJObject()
  var query_580439 = newJObject()
  var body_580440 = newJObject()
  add(query_580439, "key", newJString(key))
  add(query_580439, "prettyPrint", newJBool(prettyPrint))
  add(query_580439, "oauth_token", newJString(oauthToken))
  add(path_580438, "projectId", newJString(projectId))
  add(query_580439, "$.xgafv", newJString(Xgafv))
  add(query_580439, "alt", newJString(alt))
  add(query_580439, "uploadType", newJString(uploadType))
  add(query_580439, "quotaUser", newJString(quotaUser))
  add(path_580438, "clusterId", newJString(clusterId))
  add(path_580438, "zone", newJString(zone))
  if body != nil:
    body_580440 = body
  add(query_580439, "callback", newJString(callback))
  add(query_580439, "fields", newJString(fields))
  add(query_580439, "access_token", newJString(accessToken))
  add(query_580439, "upload_protocol", newJString(uploadProtocol))
  result = call_580437.call(path_580438, query_580439, nil, nil, body_580440)

var containerProjectsZonesClustersSetMaintenancePolicy* = Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580418(
    name: "containerProjectsZonesClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMaintenancePolicy",
    validator: validate_ContainerProjectsZonesClustersSetMaintenancePolicy_580419,
    base: "/", url: url_ContainerProjectsZonesClustersSetMaintenancePolicy_580420,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMasterAuth_580441 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersSetMasterAuth_580443(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersSetMasterAuth_580442(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580444 = path.getOrDefault("projectId")
  valid_580444 = validateParameter(valid_580444, JString, required = true,
                                 default = nil)
  if valid_580444 != nil:
    section.add "projectId", valid_580444
  var valid_580445 = path.getOrDefault("clusterId")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "clusterId", valid_580445
  var valid_580446 = path.getOrDefault("zone")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "zone", valid_580446
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580447 = query.getOrDefault("key")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "key", valid_580447
  var valid_580448 = query.getOrDefault("prettyPrint")
  valid_580448 = validateParameter(valid_580448, JBool, required = false,
                                 default = newJBool(true))
  if valid_580448 != nil:
    section.add "prettyPrint", valid_580448
  var valid_580449 = query.getOrDefault("oauth_token")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "oauth_token", valid_580449
  var valid_580450 = query.getOrDefault("$.xgafv")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = newJString("1"))
  if valid_580450 != nil:
    section.add "$.xgafv", valid_580450
  var valid_580451 = query.getOrDefault("alt")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = newJString("json"))
  if valid_580451 != nil:
    section.add "alt", valid_580451
  var valid_580452 = query.getOrDefault("uploadType")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "uploadType", valid_580452
  var valid_580453 = query.getOrDefault("quotaUser")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "quotaUser", valid_580453
  var valid_580454 = query.getOrDefault("callback")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "callback", valid_580454
  var valid_580455 = query.getOrDefault("fields")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "fields", valid_580455
  var valid_580456 = query.getOrDefault("access_token")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "access_token", valid_580456
  var valid_580457 = query.getOrDefault("upload_protocol")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "upload_protocol", valid_580457
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

proc call*(call_580459: Call_ContainerProjectsZonesClustersSetMasterAuth_580441;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_580459.validator(path, query, header, formData, body)
  let scheme = call_580459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580459.url(scheme.get, call_580459.host, call_580459.base,
                         call_580459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580459, url, valid)

proc call*(call_580460: Call_ContainerProjectsZonesClustersSetMasterAuth_580441;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersSetMasterAuth
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster to upgrade.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580461 = newJObject()
  var query_580462 = newJObject()
  var body_580463 = newJObject()
  add(query_580462, "key", newJString(key))
  add(query_580462, "prettyPrint", newJBool(prettyPrint))
  add(query_580462, "oauth_token", newJString(oauthToken))
  add(path_580461, "projectId", newJString(projectId))
  add(query_580462, "$.xgafv", newJString(Xgafv))
  add(query_580462, "alt", newJString(alt))
  add(query_580462, "uploadType", newJString(uploadType))
  add(query_580462, "quotaUser", newJString(quotaUser))
  add(path_580461, "clusterId", newJString(clusterId))
  add(path_580461, "zone", newJString(zone))
  if body != nil:
    body_580463 = body
  add(query_580462, "callback", newJString(callback))
  add(query_580462, "fields", newJString(fields))
  add(query_580462, "access_token", newJString(accessToken))
  add(query_580462, "upload_protocol", newJString(uploadProtocol))
  result = call_580460.call(path_580461, query_580462, nil, nil, body_580463)

var containerProjectsZonesClustersSetMasterAuth* = Call_ContainerProjectsZonesClustersSetMasterAuth_580441(
    name: "containerProjectsZonesClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMasterAuth",
    validator: validate_ContainerProjectsZonesClustersSetMasterAuth_580442,
    base: "/", url: url_ContainerProjectsZonesClustersSetMasterAuth_580443,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetNetworkPolicy_580464 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersSetNetworkPolicy_580466(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersSetNetworkPolicy_580465(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables or disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580467 = path.getOrDefault("projectId")
  valid_580467 = validateParameter(valid_580467, JString, required = true,
                                 default = nil)
  if valid_580467 != nil:
    section.add "projectId", valid_580467
  var valid_580468 = path.getOrDefault("clusterId")
  valid_580468 = validateParameter(valid_580468, JString, required = true,
                                 default = nil)
  if valid_580468 != nil:
    section.add "clusterId", valid_580468
  var valid_580469 = path.getOrDefault("zone")
  valid_580469 = validateParameter(valid_580469, JString, required = true,
                                 default = nil)
  if valid_580469 != nil:
    section.add "zone", valid_580469
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580470 = query.getOrDefault("key")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "key", valid_580470
  var valid_580471 = query.getOrDefault("prettyPrint")
  valid_580471 = validateParameter(valid_580471, JBool, required = false,
                                 default = newJBool(true))
  if valid_580471 != nil:
    section.add "prettyPrint", valid_580471
  var valid_580472 = query.getOrDefault("oauth_token")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "oauth_token", valid_580472
  var valid_580473 = query.getOrDefault("$.xgafv")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = newJString("1"))
  if valid_580473 != nil:
    section.add "$.xgafv", valid_580473
  var valid_580474 = query.getOrDefault("alt")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = newJString("json"))
  if valid_580474 != nil:
    section.add "alt", valid_580474
  var valid_580475 = query.getOrDefault("uploadType")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "uploadType", valid_580475
  var valid_580476 = query.getOrDefault("quotaUser")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "quotaUser", valid_580476
  var valid_580477 = query.getOrDefault("callback")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "callback", valid_580477
  var valid_580478 = query.getOrDefault("fields")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "fields", valid_580478
  var valid_580479 = query.getOrDefault("access_token")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "access_token", valid_580479
  var valid_580480 = query.getOrDefault("upload_protocol")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "upload_protocol", valid_580480
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

proc call*(call_580482: Call_ContainerProjectsZonesClustersSetNetworkPolicy_580464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_580482.validator(path, query, header, formData, body)
  let scheme = call_580482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580482.url(scheme.get, call_580482.host, call_580482.base,
                         call_580482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580482, url, valid)

proc call*(call_580483: Call_ContainerProjectsZonesClustersSetNetworkPolicy_580464;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersSetNetworkPolicy
  ## Enables or disables Network Policy for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580484 = newJObject()
  var query_580485 = newJObject()
  var body_580486 = newJObject()
  add(query_580485, "key", newJString(key))
  add(query_580485, "prettyPrint", newJBool(prettyPrint))
  add(query_580485, "oauth_token", newJString(oauthToken))
  add(path_580484, "projectId", newJString(projectId))
  add(query_580485, "$.xgafv", newJString(Xgafv))
  add(query_580485, "alt", newJString(alt))
  add(query_580485, "uploadType", newJString(uploadType))
  add(query_580485, "quotaUser", newJString(quotaUser))
  add(path_580484, "clusterId", newJString(clusterId))
  add(path_580484, "zone", newJString(zone))
  if body != nil:
    body_580486 = body
  add(query_580485, "callback", newJString(callback))
  add(query_580485, "fields", newJString(fields))
  add(query_580485, "access_token", newJString(accessToken))
  add(query_580485, "upload_protocol", newJString(uploadProtocol))
  result = call_580483.call(path_580484, query_580485, nil, nil, body_580486)

var containerProjectsZonesClustersSetNetworkPolicy* = Call_ContainerProjectsZonesClustersSetNetworkPolicy_580464(
    name: "containerProjectsZonesClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setNetworkPolicy",
    validator: validate_ContainerProjectsZonesClustersSetNetworkPolicy_580465,
    base: "/", url: url_ContainerProjectsZonesClustersSetNetworkPolicy_580466,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersStartIpRotation_580487 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesClustersStartIpRotation_580489(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesClustersStartIpRotation_580488(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580490 = path.getOrDefault("projectId")
  valid_580490 = validateParameter(valid_580490, JString, required = true,
                                 default = nil)
  if valid_580490 != nil:
    section.add "projectId", valid_580490
  var valid_580491 = path.getOrDefault("clusterId")
  valid_580491 = validateParameter(valid_580491, JString, required = true,
                                 default = nil)
  if valid_580491 != nil:
    section.add "clusterId", valid_580491
  var valid_580492 = path.getOrDefault("zone")
  valid_580492 = validateParameter(valid_580492, JString, required = true,
                                 default = nil)
  if valid_580492 != nil:
    section.add "zone", valid_580492
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580493 = query.getOrDefault("key")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "key", valid_580493
  var valid_580494 = query.getOrDefault("prettyPrint")
  valid_580494 = validateParameter(valid_580494, JBool, required = false,
                                 default = newJBool(true))
  if valid_580494 != nil:
    section.add "prettyPrint", valid_580494
  var valid_580495 = query.getOrDefault("oauth_token")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "oauth_token", valid_580495
  var valid_580496 = query.getOrDefault("$.xgafv")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = newJString("1"))
  if valid_580496 != nil:
    section.add "$.xgafv", valid_580496
  var valid_580497 = query.getOrDefault("alt")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = newJString("json"))
  if valid_580497 != nil:
    section.add "alt", valid_580497
  var valid_580498 = query.getOrDefault("uploadType")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "uploadType", valid_580498
  var valid_580499 = query.getOrDefault("quotaUser")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "quotaUser", valid_580499
  var valid_580500 = query.getOrDefault("callback")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "callback", valid_580500
  var valid_580501 = query.getOrDefault("fields")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "fields", valid_580501
  var valid_580502 = query.getOrDefault("access_token")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "access_token", valid_580502
  var valid_580503 = query.getOrDefault("upload_protocol")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "upload_protocol", valid_580503
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

proc call*(call_580505: Call_ContainerProjectsZonesClustersStartIpRotation_580487;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_580505.validator(path, query, header, formData, body)
  let scheme = call_580505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580505.url(scheme.get, call_580505.host, call_580505.base,
                         call_580505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580505, url, valid)

proc call*(call_580506: Call_ContainerProjectsZonesClustersStartIpRotation_580487;
          projectId: string; clusterId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersStartIpRotation
  ## Starts master IP rotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580507 = newJObject()
  var query_580508 = newJObject()
  var body_580509 = newJObject()
  add(query_580508, "key", newJString(key))
  add(query_580508, "prettyPrint", newJBool(prettyPrint))
  add(query_580508, "oauth_token", newJString(oauthToken))
  add(path_580507, "projectId", newJString(projectId))
  add(query_580508, "$.xgafv", newJString(Xgafv))
  add(query_580508, "alt", newJString(alt))
  add(query_580508, "uploadType", newJString(uploadType))
  add(query_580508, "quotaUser", newJString(quotaUser))
  add(path_580507, "clusterId", newJString(clusterId))
  add(path_580507, "zone", newJString(zone))
  if body != nil:
    body_580509 = body
  add(query_580508, "callback", newJString(callback))
  add(query_580508, "fields", newJString(fields))
  add(query_580508, "access_token", newJString(accessToken))
  add(query_580508, "upload_protocol", newJString(uploadProtocol))
  result = call_580506.call(path_580507, query_580508, nil, nil, body_580509)

var containerProjectsZonesClustersStartIpRotation* = Call_ContainerProjectsZonesClustersStartIpRotation_580487(
    name: "containerProjectsZonesClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:startIpRotation",
    validator: validate_ContainerProjectsZonesClustersStartIpRotation_580488,
    base: "/", url: url_ContainerProjectsZonesClustersStartIpRotation_580489,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsList_580510 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesOperationsList_580512(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsList_580511(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580513 = path.getOrDefault("projectId")
  valid_580513 = validateParameter(valid_580513, JString, required = true,
                                 default = nil)
  if valid_580513 != nil:
    section.add "projectId", valid_580513
  var valid_580514 = path.getOrDefault("zone")
  valid_580514 = validateParameter(valid_580514, JString, required = true,
                                 default = nil)
  if valid_580514 != nil:
    section.add "zone", valid_580514
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580515 = query.getOrDefault("key")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "key", valid_580515
  var valid_580516 = query.getOrDefault("prettyPrint")
  valid_580516 = validateParameter(valid_580516, JBool, required = false,
                                 default = newJBool(true))
  if valid_580516 != nil:
    section.add "prettyPrint", valid_580516
  var valid_580517 = query.getOrDefault("oauth_token")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "oauth_token", valid_580517
  var valid_580518 = query.getOrDefault("$.xgafv")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = newJString("1"))
  if valid_580518 != nil:
    section.add "$.xgafv", valid_580518
  var valid_580519 = query.getOrDefault("alt")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = newJString("json"))
  if valid_580519 != nil:
    section.add "alt", valid_580519
  var valid_580520 = query.getOrDefault("uploadType")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "uploadType", valid_580520
  var valid_580521 = query.getOrDefault("parent")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "parent", valid_580521
  var valid_580522 = query.getOrDefault("quotaUser")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "quotaUser", valid_580522
  var valid_580523 = query.getOrDefault("callback")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "callback", valid_580523
  var valid_580524 = query.getOrDefault("fields")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "fields", valid_580524
  var valid_580525 = query.getOrDefault("access_token")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "access_token", valid_580525
  var valid_580526 = query.getOrDefault("upload_protocol")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "upload_protocol", valid_580526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580527: Call_ContainerProjectsZonesOperationsList_580510;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_580527.validator(path, query, header, formData, body)
  let scheme = call_580527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580527.url(scheme.get, call_580527.host, call_580527.base,
                         call_580527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580527, url, valid)

proc call*(call_580528: Call_ContainerProjectsZonesOperationsList_580510;
          projectId: string; zone: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580529 = newJObject()
  var query_580530 = newJObject()
  add(query_580530, "key", newJString(key))
  add(query_580530, "prettyPrint", newJBool(prettyPrint))
  add(query_580530, "oauth_token", newJString(oauthToken))
  add(path_580529, "projectId", newJString(projectId))
  add(query_580530, "$.xgafv", newJString(Xgafv))
  add(query_580530, "alt", newJString(alt))
  add(query_580530, "uploadType", newJString(uploadType))
  add(query_580530, "parent", newJString(parent))
  add(query_580530, "quotaUser", newJString(quotaUser))
  add(path_580529, "zone", newJString(zone))
  add(query_580530, "callback", newJString(callback))
  add(query_580530, "fields", newJString(fields))
  add(query_580530, "access_token", newJString(accessToken))
  add(query_580530, "upload_protocol", newJString(uploadProtocol))
  result = call_580528.call(path_580529, query_580530, nil, nil, nil)

var containerProjectsZonesOperationsList* = Call_ContainerProjectsZonesOperationsList_580510(
    name: "containerProjectsZonesOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations",
    validator: validate_ContainerProjectsZonesOperationsList_580511, base: "/",
    url: url_ContainerProjectsZonesOperationsList_580512, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsGet_580531 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesOperationsGet_580533(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsGet_580532(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   operationId: JString (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580534 = path.getOrDefault("projectId")
  valid_580534 = validateParameter(valid_580534, JString, required = true,
                                 default = nil)
  if valid_580534 != nil:
    section.add "projectId", valid_580534
  var valid_580535 = path.getOrDefault("operationId")
  valid_580535 = validateParameter(valid_580535, JString, required = true,
                                 default = nil)
  if valid_580535 != nil:
    section.add "operationId", valid_580535
  var valid_580536 = path.getOrDefault("zone")
  valid_580536 = validateParameter(valid_580536, JString, required = true,
                                 default = nil)
  if valid_580536 != nil:
    section.add "zone", valid_580536
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, operation id) of the operation to get.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580537 = query.getOrDefault("key")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "key", valid_580537
  var valid_580538 = query.getOrDefault("prettyPrint")
  valid_580538 = validateParameter(valid_580538, JBool, required = false,
                                 default = newJBool(true))
  if valid_580538 != nil:
    section.add "prettyPrint", valid_580538
  var valid_580539 = query.getOrDefault("oauth_token")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "oauth_token", valid_580539
  var valid_580540 = query.getOrDefault("name")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "name", valid_580540
  var valid_580541 = query.getOrDefault("$.xgafv")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = newJString("1"))
  if valid_580541 != nil:
    section.add "$.xgafv", valid_580541
  var valid_580542 = query.getOrDefault("alt")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = newJString("json"))
  if valid_580542 != nil:
    section.add "alt", valid_580542
  var valid_580543 = query.getOrDefault("uploadType")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "uploadType", valid_580543
  var valid_580544 = query.getOrDefault("quotaUser")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "quotaUser", valid_580544
  var valid_580545 = query.getOrDefault("callback")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "callback", valid_580545
  var valid_580546 = query.getOrDefault("fields")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "fields", valid_580546
  var valid_580547 = query.getOrDefault("access_token")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "access_token", valid_580547
  var valid_580548 = query.getOrDefault("upload_protocol")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "upload_protocol", valid_580548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580549: Call_ContainerProjectsZonesOperationsGet_580531;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified operation.
  ## 
  let valid = call_580549.validator(path, query, header, formData, body)
  let scheme = call_580549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580549.url(scheme.get, call_580549.host, call_580549.base,
                         call_580549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580549, url, valid)

proc call*(call_580550: Call_ContainerProjectsZonesOperationsGet_580531;
          projectId: string; operationId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; name: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesOperationsGet
  ## Gets the specified operation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project, location, operation id) of the operation to get.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   operationId: string (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580551 = newJObject()
  var query_580552 = newJObject()
  add(query_580552, "key", newJString(key))
  add(query_580552, "prettyPrint", newJBool(prettyPrint))
  add(query_580552, "oauth_token", newJString(oauthToken))
  add(query_580552, "name", newJString(name))
  add(path_580551, "projectId", newJString(projectId))
  add(query_580552, "$.xgafv", newJString(Xgafv))
  add(path_580551, "operationId", newJString(operationId))
  add(query_580552, "alt", newJString(alt))
  add(query_580552, "uploadType", newJString(uploadType))
  add(query_580552, "quotaUser", newJString(quotaUser))
  add(path_580551, "zone", newJString(zone))
  add(query_580552, "callback", newJString(callback))
  add(query_580552, "fields", newJString(fields))
  add(query_580552, "access_token", newJString(accessToken))
  add(query_580552, "upload_protocol", newJString(uploadProtocol))
  result = call_580550.call(path_580551, query_580552, nil, nil, nil)

var containerProjectsZonesOperationsGet* = Call_ContainerProjectsZonesOperationsGet_580531(
    name: "containerProjectsZonesOperationsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}",
    validator: validate_ContainerProjectsZonesOperationsGet_580532, base: "/",
    url: url_ContainerProjectsZonesOperationsGet_580533, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsCancel_580553 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesOperationsCancel_580555(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesOperationsCancel_580554(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   operationId: JString (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580556 = path.getOrDefault("projectId")
  valid_580556 = validateParameter(valid_580556, JString, required = true,
                                 default = nil)
  if valid_580556 != nil:
    section.add "projectId", valid_580556
  var valid_580557 = path.getOrDefault("operationId")
  valid_580557 = validateParameter(valid_580557, JString, required = true,
                                 default = nil)
  if valid_580557 != nil:
    section.add "operationId", valid_580557
  var valid_580558 = path.getOrDefault("zone")
  valid_580558 = validateParameter(valid_580558, JString, required = true,
                                 default = nil)
  if valid_580558 != nil:
    section.add "zone", valid_580558
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580559 = query.getOrDefault("key")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "key", valid_580559
  var valid_580560 = query.getOrDefault("prettyPrint")
  valid_580560 = validateParameter(valid_580560, JBool, required = false,
                                 default = newJBool(true))
  if valid_580560 != nil:
    section.add "prettyPrint", valid_580560
  var valid_580561 = query.getOrDefault("oauth_token")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "oauth_token", valid_580561
  var valid_580562 = query.getOrDefault("$.xgafv")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = newJString("1"))
  if valid_580562 != nil:
    section.add "$.xgafv", valid_580562
  var valid_580563 = query.getOrDefault("alt")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = newJString("json"))
  if valid_580563 != nil:
    section.add "alt", valid_580563
  var valid_580564 = query.getOrDefault("uploadType")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "uploadType", valid_580564
  var valid_580565 = query.getOrDefault("quotaUser")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "quotaUser", valid_580565
  var valid_580566 = query.getOrDefault("callback")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "callback", valid_580566
  var valid_580567 = query.getOrDefault("fields")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "fields", valid_580567
  var valid_580568 = query.getOrDefault("access_token")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "access_token", valid_580568
  var valid_580569 = query.getOrDefault("upload_protocol")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "upload_protocol", valid_580569
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

proc call*(call_580571: Call_ContainerProjectsZonesOperationsCancel_580553;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_580571.validator(path, query, header, formData, body)
  let scheme = call_580571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580571.url(scheme.get, call_580571.host, call_580571.base,
                         call_580571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580571, url, valid)

proc call*(call_580572: Call_ContainerProjectsZonesOperationsCancel_580553;
          projectId: string; operationId: string; zone: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesOperationsCancel
  ## Cancels the specified operation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   operationId: string (required)
  ##              : Deprecated. The server-assigned `name` of the operation.
  ## This field has been deprecated and replaced by the name field.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field has been deprecated and replaced by the name field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580573 = newJObject()
  var query_580574 = newJObject()
  var body_580575 = newJObject()
  add(query_580574, "key", newJString(key))
  add(query_580574, "prettyPrint", newJBool(prettyPrint))
  add(query_580574, "oauth_token", newJString(oauthToken))
  add(path_580573, "projectId", newJString(projectId))
  add(query_580574, "$.xgafv", newJString(Xgafv))
  add(path_580573, "operationId", newJString(operationId))
  add(query_580574, "alt", newJString(alt))
  add(query_580574, "uploadType", newJString(uploadType))
  add(query_580574, "quotaUser", newJString(quotaUser))
  add(path_580573, "zone", newJString(zone))
  if body != nil:
    body_580575 = body
  add(query_580574, "callback", newJString(callback))
  add(query_580574, "fields", newJString(fields))
  add(query_580574, "access_token", newJString(accessToken))
  add(query_580574, "upload_protocol", newJString(uploadProtocol))
  result = call_580572.call(path_580573, query_580574, nil, nil, body_580575)

var containerProjectsZonesOperationsCancel* = Call_ContainerProjectsZonesOperationsCancel_580553(
    name: "containerProjectsZonesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}:cancel",
    validator: validate_ContainerProjectsZonesOperationsCancel_580554, base: "/",
    url: url_ContainerProjectsZonesOperationsCancel_580555,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesGetServerconfig_580576 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsZonesGetServerconfig_580578(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsZonesGetServerconfig_580577(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580579 = path.getOrDefault("projectId")
  valid_580579 = validateParameter(valid_580579, JString, required = true,
                                 default = nil)
  if valid_580579 != nil:
    section.add "projectId", valid_580579
  var valid_580580 = path.getOrDefault("zone")
  valid_580580 = validateParameter(valid_580580, JString, required = true,
                                 default = nil)
  if valid_580580 != nil:
    section.add "zone", valid_580580
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580581 = query.getOrDefault("key")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "key", valid_580581
  var valid_580582 = query.getOrDefault("prettyPrint")
  valid_580582 = validateParameter(valid_580582, JBool, required = false,
                                 default = newJBool(true))
  if valid_580582 != nil:
    section.add "prettyPrint", valid_580582
  var valid_580583 = query.getOrDefault("oauth_token")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "oauth_token", valid_580583
  var valid_580584 = query.getOrDefault("name")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "name", valid_580584
  var valid_580585 = query.getOrDefault("$.xgafv")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = newJString("1"))
  if valid_580585 != nil:
    section.add "$.xgafv", valid_580585
  var valid_580586 = query.getOrDefault("alt")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = newJString("json"))
  if valid_580586 != nil:
    section.add "alt", valid_580586
  var valid_580587 = query.getOrDefault("uploadType")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "uploadType", valid_580587
  var valid_580588 = query.getOrDefault("quotaUser")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "quotaUser", valid_580588
  var valid_580589 = query.getOrDefault("callback")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "callback", valid_580589
  var valid_580590 = query.getOrDefault("fields")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "fields", valid_580590
  var valid_580591 = query.getOrDefault("access_token")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "access_token", valid_580591
  var valid_580592 = query.getOrDefault("upload_protocol")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "upload_protocol", valid_580592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580593: Call_ContainerProjectsZonesGetServerconfig_580576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_580593.validator(path, query, header, formData, body)
  let scheme = call_580593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580593.url(scheme.get, call_580593.host, call_580593.base,
                         call_580593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580593, url, valid)

proc call*(call_580594: Call_ContainerProjectsZonesGetServerconfig_580576;
          projectId: string; zone: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesGetServerconfig
  ## Returns configuration info about the Google Kubernetes Engine service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  ##   projectId: string (required)
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580595 = newJObject()
  var query_580596 = newJObject()
  add(query_580596, "key", newJString(key))
  add(query_580596, "prettyPrint", newJBool(prettyPrint))
  add(query_580596, "oauth_token", newJString(oauthToken))
  add(query_580596, "name", newJString(name))
  add(path_580595, "projectId", newJString(projectId))
  add(query_580596, "$.xgafv", newJString(Xgafv))
  add(query_580596, "alt", newJString(alt))
  add(query_580596, "uploadType", newJString(uploadType))
  add(query_580596, "quotaUser", newJString(quotaUser))
  add(path_580595, "zone", newJString(zone))
  add(query_580596, "callback", newJString(callback))
  add(query_580596, "fields", newJString(fields))
  add(query_580596, "access_token", newJString(accessToken))
  add(query_580596, "upload_protocol", newJString(uploadProtocol))
  result = call_580594.call(path_580595, query_580596, nil, nil, nil)

var containerProjectsZonesGetServerconfig* = Call_ContainerProjectsZonesGetServerconfig_580576(
    name: "containerProjectsZonesGetServerconfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/serverconfig",
    validator: validate_ContainerProjectsZonesGetServerconfig_580577, base: "/",
    url: url_ContainerProjectsZonesGetServerconfig_580578, schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580620 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersNodePoolsUpdate_580622(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsUpdate_580621(
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
  var valid_580623 = path.getOrDefault("name")
  valid_580623 = validateParameter(valid_580623, JString, required = true,
                                 default = nil)
  if valid_580623 != nil:
    section.add "name", valid_580623
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580624 = query.getOrDefault("key")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "key", valid_580624
  var valid_580625 = query.getOrDefault("prettyPrint")
  valid_580625 = validateParameter(valid_580625, JBool, required = false,
                                 default = newJBool(true))
  if valid_580625 != nil:
    section.add "prettyPrint", valid_580625
  var valid_580626 = query.getOrDefault("oauth_token")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "oauth_token", valid_580626
  var valid_580627 = query.getOrDefault("$.xgafv")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = newJString("1"))
  if valid_580627 != nil:
    section.add "$.xgafv", valid_580627
  var valid_580628 = query.getOrDefault("alt")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = newJString("json"))
  if valid_580628 != nil:
    section.add "alt", valid_580628
  var valid_580629 = query.getOrDefault("uploadType")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "uploadType", valid_580629
  var valid_580630 = query.getOrDefault("quotaUser")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "quotaUser", valid_580630
  var valid_580631 = query.getOrDefault("callback")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "callback", valid_580631
  var valid_580632 = query.getOrDefault("fields")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "fields", valid_580632
  var valid_580633 = query.getOrDefault("access_token")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "access_token", valid_580633
  var valid_580634 = query.getOrDefault("upload_protocol")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "upload_protocol", valid_580634
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

proc call*(call_580636: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580620;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_580636.validator(path, query, header, formData, body)
  let scheme = call_580636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580636.url(scheme.get, call_580636.host, call_580636.base,
                         call_580636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580636, url, valid)

proc call*(call_580637: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580620;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsUpdate
  ## Updates the version and/or image type for the specified node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to
  ## update. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580638 = newJObject()
  var query_580639 = newJObject()
  var body_580640 = newJObject()
  add(query_580639, "key", newJString(key))
  add(query_580639, "prettyPrint", newJBool(prettyPrint))
  add(query_580639, "oauth_token", newJString(oauthToken))
  add(query_580639, "$.xgafv", newJString(Xgafv))
  add(query_580639, "alt", newJString(alt))
  add(query_580639, "uploadType", newJString(uploadType))
  add(query_580639, "quotaUser", newJString(quotaUser))
  add(path_580638, "name", newJString(name))
  if body != nil:
    body_580640 = body
  add(query_580639, "callback", newJString(callback))
  add(query_580639, "fields", newJString(fields))
  add(query_580639, "access_token", newJString(accessToken))
  add(query_580639, "upload_protocol", newJString(uploadProtocol))
  result = call_580637.call(path_580638, query_580639, nil, nil, body_580640)

var containerProjectsLocationsClustersNodePoolsUpdate* = Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580620(
    name: "containerProjectsLocationsClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPut, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsUpdate_580621,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsUpdate_580622,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsGet_580597 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersNodePoolsGet_580599(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsGet_580598(
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
  var valid_580600 = path.getOrDefault("name")
  valid_580600 = validateParameter(valid_580600, JString, required = true,
                                 default = nil)
  if valid_580600 != nil:
    section.add "name", valid_580600
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   nodePoolId: JString
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  var valid_580601 = query.getOrDefault("key")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "key", valid_580601
  var valid_580602 = query.getOrDefault("prettyPrint")
  valid_580602 = validateParameter(valid_580602, JBool, required = false,
                                 default = newJBool(true))
  if valid_580602 != nil:
    section.add "prettyPrint", valid_580602
  var valid_580603 = query.getOrDefault("oauth_token")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "oauth_token", valid_580603
  var valid_580604 = query.getOrDefault("$.xgafv")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = newJString("1"))
  if valid_580604 != nil:
    section.add "$.xgafv", valid_580604
  var valid_580605 = query.getOrDefault("alt")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = newJString("json"))
  if valid_580605 != nil:
    section.add "alt", valid_580605
  var valid_580606 = query.getOrDefault("uploadType")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "uploadType", valid_580606
  var valid_580607 = query.getOrDefault("quotaUser")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "quotaUser", valid_580607
  var valid_580608 = query.getOrDefault("nodePoolId")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = nil)
  if valid_580608 != nil:
    section.add "nodePoolId", valid_580608
  var valid_580609 = query.getOrDefault("clusterId")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "clusterId", valid_580609
  var valid_580610 = query.getOrDefault("zone")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "zone", valid_580610
  var valid_580611 = query.getOrDefault("callback")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "callback", valid_580611
  var valid_580612 = query.getOrDefault("fields")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "fields", valid_580612
  var valid_580613 = query.getOrDefault("access_token")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "access_token", valid_580613
  var valid_580614 = query.getOrDefault("upload_protocol")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "upload_protocol", valid_580614
  var valid_580615 = query.getOrDefault("projectId")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "projectId", valid_580615
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580616: Call_ContainerProjectsLocationsClustersNodePoolsGet_580597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_580616.validator(path, query, header, formData, body)
  let scheme = call_580616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580616.url(scheme.get, call_580616.host, call_580616.base,
                         call_580616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580616, url, valid)

proc call*(call_580617: Call_ContainerProjectsLocationsClustersNodePoolsGet_580597;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; nodePoolId: string = "";
          clusterId: string = ""; zone: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsGet
  ## Retrieves the requested node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## get. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   nodePoolId: string
  ##             : Deprecated. The name of the node pool.
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: string
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  var path_580618 = newJObject()
  var query_580619 = newJObject()
  add(query_580619, "key", newJString(key))
  add(query_580619, "prettyPrint", newJBool(prettyPrint))
  add(query_580619, "oauth_token", newJString(oauthToken))
  add(query_580619, "$.xgafv", newJString(Xgafv))
  add(query_580619, "alt", newJString(alt))
  add(query_580619, "uploadType", newJString(uploadType))
  add(query_580619, "quotaUser", newJString(quotaUser))
  add(path_580618, "name", newJString(name))
  add(query_580619, "nodePoolId", newJString(nodePoolId))
  add(query_580619, "clusterId", newJString(clusterId))
  add(query_580619, "zone", newJString(zone))
  add(query_580619, "callback", newJString(callback))
  add(query_580619, "fields", newJString(fields))
  add(query_580619, "access_token", newJString(accessToken))
  add(query_580619, "upload_protocol", newJString(uploadProtocol))
  add(query_580619, "projectId", newJString(projectId))
  result = call_580617.call(path_580618, query_580619, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsGet* = Call_ContainerProjectsLocationsClustersNodePoolsGet_580597(
    name: "containerProjectsLocationsClustersNodePoolsGet",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsGet_580598,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsGet_580599,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsDelete_580641 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersNodePoolsDelete_580643(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsDelete_580642(
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
  var valid_580644 = path.getOrDefault("name")
  valid_580644 = validateParameter(valid_580644, JString, required = true,
                                 default = nil)
  if valid_580644 != nil:
    section.add "name", valid_580644
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   nodePoolId: JString
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: JString
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  var valid_580645 = query.getOrDefault("key")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "key", valid_580645
  var valid_580646 = query.getOrDefault("prettyPrint")
  valid_580646 = validateParameter(valid_580646, JBool, required = false,
                                 default = newJBool(true))
  if valid_580646 != nil:
    section.add "prettyPrint", valid_580646
  var valid_580647 = query.getOrDefault("oauth_token")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "oauth_token", valid_580647
  var valid_580648 = query.getOrDefault("$.xgafv")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = newJString("1"))
  if valid_580648 != nil:
    section.add "$.xgafv", valid_580648
  var valid_580649 = query.getOrDefault("alt")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = newJString("json"))
  if valid_580649 != nil:
    section.add "alt", valid_580649
  var valid_580650 = query.getOrDefault("uploadType")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "uploadType", valid_580650
  var valid_580651 = query.getOrDefault("quotaUser")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "quotaUser", valid_580651
  var valid_580652 = query.getOrDefault("nodePoolId")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "nodePoolId", valid_580652
  var valid_580653 = query.getOrDefault("clusterId")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "clusterId", valid_580653
  var valid_580654 = query.getOrDefault("zone")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "zone", valid_580654
  var valid_580655 = query.getOrDefault("callback")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "callback", valid_580655
  var valid_580656 = query.getOrDefault("fields")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "fields", valid_580656
  var valid_580657 = query.getOrDefault("access_token")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "access_token", valid_580657
  var valid_580658 = query.getOrDefault("upload_protocol")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = nil)
  if valid_580658 != nil:
    section.add "upload_protocol", valid_580658
  var valid_580659 = query.getOrDefault("projectId")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "projectId", valid_580659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580660: Call_ContainerProjectsLocationsClustersNodePoolsDelete_580641;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_580660.validator(path, query, header, formData, body)
  let scheme = call_580660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580660.url(scheme.get, call_580660.host, call_580660.base,
                         call_580660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580660, url, valid)

proc call*(call_580661: Call_ContainerProjectsLocationsClustersNodePoolsDelete_580641;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; nodePoolId: string = "";
          clusterId: string = ""; zone: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to
  ## delete. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   nodePoolId: string
  ##             : Deprecated. The name of the node pool to delete.
  ## This field has been deprecated and replaced by the name field.
  ##   clusterId: string
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the name field.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the name field.
  var path_580662 = newJObject()
  var query_580663 = newJObject()
  add(query_580663, "key", newJString(key))
  add(query_580663, "prettyPrint", newJBool(prettyPrint))
  add(query_580663, "oauth_token", newJString(oauthToken))
  add(query_580663, "$.xgafv", newJString(Xgafv))
  add(query_580663, "alt", newJString(alt))
  add(query_580663, "uploadType", newJString(uploadType))
  add(query_580663, "quotaUser", newJString(quotaUser))
  add(path_580662, "name", newJString(name))
  add(query_580663, "nodePoolId", newJString(nodePoolId))
  add(query_580663, "clusterId", newJString(clusterId))
  add(query_580663, "zone", newJString(zone))
  add(query_580663, "callback", newJString(callback))
  add(query_580663, "fields", newJString(fields))
  add(query_580663, "access_token", newJString(accessToken))
  add(query_580663, "upload_protocol", newJString(uploadProtocol))
  add(query_580663, "projectId", newJString(projectId))
  result = call_580661.call(path_580662, query_580663, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsDelete* = Call_ContainerProjectsLocationsClustersNodePoolsDelete_580641(
    name: "containerProjectsLocationsClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsDelete_580642,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsDelete_580643,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsGetServerConfig_580664 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsGetServerConfig_580666(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsGetServerConfig_580665(path: JsonNode;
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
  var valid_580667 = path.getOrDefault("name")
  valid_580667 = validateParameter(valid_580667, JString, required = true,
                                 default = nil)
  if valid_580667 != nil:
    section.add "name", valid_580667
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  section = newJObject()
  var valid_580668 = query.getOrDefault("key")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "key", valid_580668
  var valid_580669 = query.getOrDefault("prettyPrint")
  valid_580669 = validateParameter(valid_580669, JBool, required = false,
                                 default = newJBool(true))
  if valid_580669 != nil:
    section.add "prettyPrint", valid_580669
  var valid_580670 = query.getOrDefault("oauth_token")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "oauth_token", valid_580670
  var valid_580671 = query.getOrDefault("$.xgafv")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = newJString("1"))
  if valid_580671 != nil:
    section.add "$.xgafv", valid_580671
  var valid_580672 = query.getOrDefault("alt")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = newJString("json"))
  if valid_580672 != nil:
    section.add "alt", valid_580672
  var valid_580673 = query.getOrDefault("uploadType")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "uploadType", valid_580673
  var valid_580674 = query.getOrDefault("quotaUser")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "quotaUser", valid_580674
  var valid_580675 = query.getOrDefault("zone")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "zone", valid_580675
  var valid_580676 = query.getOrDefault("callback")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "callback", valid_580676
  var valid_580677 = query.getOrDefault("fields")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "fields", valid_580677
  var valid_580678 = query.getOrDefault("access_token")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "access_token", valid_580678
  var valid_580679 = query.getOrDefault("upload_protocol")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "upload_protocol", valid_580679
  var valid_580680 = query.getOrDefault("projectId")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "projectId", valid_580680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580681: Call_ContainerProjectsLocationsGetServerConfig_580664;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_580681.validator(path, query, header, formData, body)
  let scheme = call_580681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580681.url(scheme.get, call_580681.host, call_580681.base,
                         call_580681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580681, url, valid)

proc call*(call_580682: Call_ContainerProjectsLocationsGetServerConfig_580664;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; zone: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## containerProjectsLocationsGetServerConfig
  ## Returns configuration info about the Google Kubernetes Engine service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project and location) of the server config to get,
  ## specified in the format 'projects/*/locations/*'.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for.
  ## This field has been deprecated and replaced by the name field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the name field.
  var path_580683 = newJObject()
  var query_580684 = newJObject()
  add(query_580684, "key", newJString(key))
  add(query_580684, "prettyPrint", newJBool(prettyPrint))
  add(query_580684, "oauth_token", newJString(oauthToken))
  add(query_580684, "$.xgafv", newJString(Xgafv))
  add(query_580684, "alt", newJString(alt))
  add(query_580684, "uploadType", newJString(uploadType))
  add(query_580684, "quotaUser", newJString(quotaUser))
  add(path_580683, "name", newJString(name))
  add(query_580684, "zone", newJString(zone))
  add(query_580684, "callback", newJString(callback))
  add(query_580684, "fields", newJString(fields))
  add(query_580684, "access_token", newJString(accessToken))
  add(query_580684, "upload_protocol", newJString(uploadProtocol))
  add(query_580684, "projectId", newJString(projectId))
  result = call_580682.call(path_580683, query_580684, nil, nil, nil)

var containerProjectsLocationsGetServerConfig* = Call_ContainerProjectsLocationsGetServerConfig_580664(
    name: "containerProjectsLocationsGetServerConfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{name}/serverConfig",
    validator: validate_ContainerProjectsLocationsGetServerConfig_580665,
    base: "/", url: url_ContainerProjectsLocationsGetServerConfig_580666,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsCancel_580685 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsOperationsCancel_580687(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsCancel_580686(path: JsonNode;
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
  var valid_580688 = path.getOrDefault("name")
  valid_580688 = validateParameter(valid_580688, JString, required = true,
                                 default = nil)
  if valid_580688 != nil:
    section.add "name", valid_580688
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580689 = query.getOrDefault("key")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "key", valid_580689
  var valid_580690 = query.getOrDefault("prettyPrint")
  valid_580690 = validateParameter(valid_580690, JBool, required = false,
                                 default = newJBool(true))
  if valid_580690 != nil:
    section.add "prettyPrint", valid_580690
  var valid_580691 = query.getOrDefault("oauth_token")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "oauth_token", valid_580691
  var valid_580692 = query.getOrDefault("$.xgafv")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = newJString("1"))
  if valid_580692 != nil:
    section.add "$.xgafv", valid_580692
  var valid_580693 = query.getOrDefault("alt")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = newJString("json"))
  if valid_580693 != nil:
    section.add "alt", valid_580693
  var valid_580694 = query.getOrDefault("uploadType")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "uploadType", valid_580694
  var valid_580695 = query.getOrDefault("quotaUser")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "quotaUser", valid_580695
  var valid_580696 = query.getOrDefault("callback")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "callback", valid_580696
  var valid_580697 = query.getOrDefault("fields")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "fields", valid_580697
  var valid_580698 = query.getOrDefault("access_token")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "access_token", valid_580698
  var valid_580699 = query.getOrDefault("upload_protocol")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "upload_protocol", valid_580699
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

proc call*(call_580701: Call_ContainerProjectsLocationsOperationsCancel_580685;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_580701.validator(path, query, header, formData, body)
  let scheme = call_580701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580701.url(scheme.get, call_580701.host, call_580701.base,
                         call_580701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580701, url, valid)

proc call*(call_580702: Call_ContainerProjectsLocationsOperationsCancel_580685;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsOperationsCancel
  ## Cancels the specified operation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, operation id) of the operation to cancel.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580703 = newJObject()
  var query_580704 = newJObject()
  var body_580705 = newJObject()
  add(query_580704, "key", newJString(key))
  add(query_580704, "prettyPrint", newJBool(prettyPrint))
  add(query_580704, "oauth_token", newJString(oauthToken))
  add(query_580704, "$.xgafv", newJString(Xgafv))
  add(query_580704, "alt", newJString(alt))
  add(query_580704, "uploadType", newJString(uploadType))
  add(query_580704, "quotaUser", newJString(quotaUser))
  add(path_580703, "name", newJString(name))
  if body != nil:
    body_580705 = body
  add(query_580704, "callback", newJString(callback))
  add(query_580704, "fields", newJString(fields))
  add(query_580704, "access_token", newJString(accessToken))
  add(query_580704, "upload_protocol", newJString(uploadProtocol))
  result = call_580702.call(path_580703, query_580704, nil, nil, body_580705)

var containerProjectsLocationsOperationsCancel* = Call_ContainerProjectsLocationsOperationsCancel_580685(
    name: "containerProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ContainerProjectsLocationsOperationsCancel_580686,
    base: "/", url: url_ContainerProjectsLocationsOperationsCancel_580687,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCompleteIpRotation_580706 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersCompleteIpRotation_580708(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCompleteIpRotation_580707(
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
  var valid_580709 = path.getOrDefault("name")
  valid_580709 = validateParameter(valid_580709, JString, required = true,
                                 default = nil)
  if valid_580709 != nil:
    section.add "name", valid_580709
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580710 = query.getOrDefault("key")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "key", valid_580710
  var valid_580711 = query.getOrDefault("prettyPrint")
  valid_580711 = validateParameter(valid_580711, JBool, required = false,
                                 default = newJBool(true))
  if valid_580711 != nil:
    section.add "prettyPrint", valid_580711
  var valid_580712 = query.getOrDefault("oauth_token")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "oauth_token", valid_580712
  var valid_580713 = query.getOrDefault("$.xgafv")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = newJString("1"))
  if valid_580713 != nil:
    section.add "$.xgafv", valid_580713
  var valid_580714 = query.getOrDefault("alt")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = newJString("json"))
  if valid_580714 != nil:
    section.add "alt", valid_580714
  var valid_580715 = query.getOrDefault("uploadType")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "uploadType", valid_580715
  var valid_580716 = query.getOrDefault("quotaUser")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "quotaUser", valid_580716
  var valid_580717 = query.getOrDefault("callback")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "callback", valid_580717
  var valid_580718 = query.getOrDefault("fields")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "fields", valid_580718
  var valid_580719 = query.getOrDefault("access_token")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "access_token", valid_580719
  var valid_580720 = query.getOrDefault("upload_protocol")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "upload_protocol", valid_580720
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

proc call*(call_580722: Call_ContainerProjectsLocationsClustersCompleteIpRotation_580706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_580722.validator(path, query, header, formData, body)
  let scheme = call_580722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580722.url(scheme.get, call_580722.host, call_580722.base,
                         call_580722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580722, url, valid)

proc call*(call_580723: Call_ContainerProjectsLocationsClustersCompleteIpRotation_580706;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580724 = newJObject()
  var query_580725 = newJObject()
  var body_580726 = newJObject()
  add(query_580725, "key", newJString(key))
  add(query_580725, "prettyPrint", newJBool(prettyPrint))
  add(query_580725, "oauth_token", newJString(oauthToken))
  add(query_580725, "$.xgafv", newJString(Xgafv))
  add(query_580725, "alt", newJString(alt))
  add(query_580725, "uploadType", newJString(uploadType))
  add(query_580725, "quotaUser", newJString(quotaUser))
  add(path_580724, "name", newJString(name))
  if body != nil:
    body_580726 = body
  add(query_580725, "callback", newJString(callback))
  add(query_580725, "fields", newJString(fields))
  add(query_580725, "access_token", newJString(accessToken))
  add(query_580725, "upload_protocol", newJString(uploadProtocol))
  result = call_580723.call(path_580724, query_580725, nil, nil, body_580726)

var containerProjectsLocationsClustersCompleteIpRotation* = Call_ContainerProjectsLocationsClustersCompleteIpRotation_580706(
    name: "containerProjectsLocationsClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:completeIpRotation",
    validator: validate_ContainerProjectsLocationsClustersCompleteIpRotation_580707,
    base: "/", url: url_ContainerProjectsLocationsClustersCompleteIpRotation_580708,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsRollback_580727 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersNodePoolsRollback_580729(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsRollback_580728(
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
  var valid_580730 = path.getOrDefault("name")
  valid_580730 = validateParameter(valid_580730, JString, required = true,
                                 default = nil)
  if valid_580730 != nil:
    section.add "name", valid_580730
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580731 = query.getOrDefault("key")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "key", valid_580731
  var valid_580732 = query.getOrDefault("prettyPrint")
  valid_580732 = validateParameter(valid_580732, JBool, required = false,
                                 default = newJBool(true))
  if valid_580732 != nil:
    section.add "prettyPrint", valid_580732
  var valid_580733 = query.getOrDefault("oauth_token")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "oauth_token", valid_580733
  var valid_580734 = query.getOrDefault("$.xgafv")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = newJString("1"))
  if valid_580734 != nil:
    section.add "$.xgafv", valid_580734
  var valid_580735 = query.getOrDefault("alt")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = newJString("json"))
  if valid_580735 != nil:
    section.add "alt", valid_580735
  var valid_580736 = query.getOrDefault("uploadType")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "uploadType", valid_580736
  var valid_580737 = query.getOrDefault("quotaUser")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "quotaUser", valid_580737
  var valid_580738 = query.getOrDefault("callback")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "callback", valid_580738
  var valid_580739 = query.getOrDefault("fields")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "fields", valid_580739
  var valid_580740 = query.getOrDefault("access_token")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "access_token", valid_580740
  var valid_580741 = query.getOrDefault("upload_protocol")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "upload_protocol", valid_580741
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

proc call*(call_580743: Call_ContainerProjectsLocationsClustersNodePoolsRollback_580727;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_580743.validator(path, query, header, formData, body)
  let scheme = call_580743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580743.url(scheme.get, call_580743.host, call_580743.base,
                         call_580743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580743, url, valid)

proc call*(call_580744: Call_ContainerProjectsLocationsClustersNodePoolsRollback_580727;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsRollback
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node poll to
  ## rollback upgrade.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580745 = newJObject()
  var query_580746 = newJObject()
  var body_580747 = newJObject()
  add(query_580746, "key", newJString(key))
  add(query_580746, "prettyPrint", newJBool(prettyPrint))
  add(query_580746, "oauth_token", newJString(oauthToken))
  add(query_580746, "$.xgafv", newJString(Xgafv))
  add(query_580746, "alt", newJString(alt))
  add(query_580746, "uploadType", newJString(uploadType))
  add(query_580746, "quotaUser", newJString(quotaUser))
  add(path_580745, "name", newJString(name))
  if body != nil:
    body_580747 = body
  add(query_580746, "callback", newJString(callback))
  add(query_580746, "fields", newJString(fields))
  add(query_580746, "access_token", newJString(accessToken))
  add(query_580746, "upload_protocol", newJString(uploadProtocol))
  result = call_580744.call(path_580745, query_580746, nil, nil, body_580747)

var containerProjectsLocationsClustersNodePoolsRollback* = Call_ContainerProjectsLocationsClustersNodePoolsRollback_580727(
    name: "containerProjectsLocationsClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:rollback",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsRollback_580728,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsRollback_580729,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetAddons_580748 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersSetAddons_580750(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetAddons_580749(path: JsonNode;
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
  var valid_580751 = path.getOrDefault("name")
  valid_580751 = validateParameter(valid_580751, JString, required = true,
                                 default = nil)
  if valid_580751 != nil:
    section.add "name", valid_580751
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580752 = query.getOrDefault("key")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "key", valid_580752
  var valid_580753 = query.getOrDefault("prettyPrint")
  valid_580753 = validateParameter(valid_580753, JBool, required = false,
                                 default = newJBool(true))
  if valid_580753 != nil:
    section.add "prettyPrint", valid_580753
  var valid_580754 = query.getOrDefault("oauth_token")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "oauth_token", valid_580754
  var valid_580755 = query.getOrDefault("$.xgafv")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = newJString("1"))
  if valid_580755 != nil:
    section.add "$.xgafv", valid_580755
  var valid_580756 = query.getOrDefault("alt")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = newJString("json"))
  if valid_580756 != nil:
    section.add "alt", valid_580756
  var valid_580757 = query.getOrDefault("uploadType")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "uploadType", valid_580757
  var valid_580758 = query.getOrDefault("quotaUser")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "quotaUser", valid_580758
  var valid_580759 = query.getOrDefault("callback")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "callback", valid_580759
  var valid_580760 = query.getOrDefault("fields")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "fields", valid_580760
  var valid_580761 = query.getOrDefault("access_token")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "access_token", valid_580761
  var valid_580762 = query.getOrDefault("upload_protocol")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "upload_protocol", valid_580762
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

proc call*(call_580764: Call_ContainerProjectsLocationsClustersSetAddons_580748;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_580764.validator(path, query, header, formData, body)
  let scheme = call_580764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580764.url(scheme.get, call_580764.host, call_580764.base,
                         call_580764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580764, url, valid)

proc call*(call_580765: Call_ContainerProjectsLocationsClustersSetAddons_580748;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetAddons
  ## Sets the addons for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set addons.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580766 = newJObject()
  var query_580767 = newJObject()
  var body_580768 = newJObject()
  add(query_580767, "key", newJString(key))
  add(query_580767, "prettyPrint", newJBool(prettyPrint))
  add(query_580767, "oauth_token", newJString(oauthToken))
  add(query_580767, "$.xgafv", newJString(Xgafv))
  add(query_580767, "alt", newJString(alt))
  add(query_580767, "uploadType", newJString(uploadType))
  add(query_580767, "quotaUser", newJString(quotaUser))
  add(path_580766, "name", newJString(name))
  if body != nil:
    body_580768 = body
  add(query_580767, "callback", newJString(callback))
  add(query_580767, "fields", newJString(fields))
  add(query_580767, "access_token", newJString(accessToken))
  add(query_580767, "upload_protocol", newJString(uploadProtocol))
  result = call_580765.call(path_580766, query_580767, nil, nil, body_580768)

var containerProjectsLocationsClustersSetAddons* = Call_ContainerProjectsLocationsClustersSetAddons_580748(
    name: "containerProjectsLocationsClustersSetAddons",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAddons",
    validator: validate_ContainerProjectsLocationsClustersSetAddons_580749,
    base: "/", url: url_ContainerProjectsLocationsClustersSetAddons_580750,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580769 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580771(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580770(
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
  var valid_580772 = path.getOrDefault("name")
  valid_580772 = validateParameter(valid_580772, JString, required = true,
                                 default = nil)
  if valid_580772 != nil:
    section.add "name", valid_580772
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580773 = query.getOrDefault("key")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "key", valid_580773
  var valid_580774 = query.getOrDefault("prettyPrint")
  valid_580774 = validateParameter(valid_580774, JBool, required = false,
                                 default = newJBool(true))
  if valid_580774 != nil:
    section.add "prettyPrint", valid_580774
  var valid_580775 = query.getOrDefault("oauth_token")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "oauth_token", valid_580775
  var valid_580776 = query.getOrDefault("$.xgafv")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = newJString("1"))
  if valid_580776 != nil:
    section.add "$.xgafv", valid_580776
  var valid_580777 = query.getOrDefault("alt")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = newJString("json"))
  if valid_580777 != nil:
    section.add "alt", valid_580777
  var valid_580778 = query.getOrDefault("uploadType")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "uploadType", valid_580778
  var valid_580779 = query.getOrDefault("quotaUser")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "quotaUser", valid_580779
  var valid_580780 = query.getOrDefault("callback")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "callback", valid_580780
  var valid_580781 = query.getOrDefault("fields")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "fields", valid_580781
  var valid_580782 = query.getOrDefault("access_token")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "access_token", valid_580782
  var valid_580783 = query.getOrDefault("upload_protocol")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "upload_protocol", valid_580783
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

proc call*(call_580785: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580769;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_580785.validator(path, query, header, formData, body)
  let scheme = call_580785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580785.url(scheme.get, call_580785.host, call_580785.base,
                         call_580785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580785, url, valid)

proc call*(call_580786: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580769;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetAutoscaling
  ## Sets the autoscaling settings for the specified node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to set
  ## autoscaler settings. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580787 = newJObject()
  var query_580788 = newJObject()
  var body_580789 = newJObject()
  add(query_580788, "key", newJString(key))
  add(query_580788, "prettyPrint", newJBool(prettyPrint))
  add(query_580788, "oauth_token", newJString(oauthToken))
  add(query_580788, "$.xgafv", newJString(Xgafv))
  add(query_580788, "alt", newJString(alt))
  add(query_580788, "uploadType", newJString(uploadType))
  add(query_580788, "quotaUser", newJString(quotaUser))
  add(path_580787, "name", newJString(name))
  if body != nil:
    body_580789 = body
  add(query_580788, "callback", newJString(callback))
  add(query_580788, "fields", newJString(fields))
  add(query_580788, "access_token", newJString(accessToken))
  add(query_580788, "upload_protocol", newJString(uploadProtocol))
  result = call_580786.call(path_580787, query_580788, nil, nil, body_580789)

var containerProjectsLocationsClustersNodePoolsSetAutoscaling* = Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580769(
    name: "containerProjectsLocationsClustersNodePoolsSetAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAutoscaling", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580770,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580771,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLegacyAbac_580790 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersSetLegacyAbac_580792(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLegacyAbac_580791(
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
  var valid_580793 = path.getOrDefault("name")
  valid_580793 = validateParameter(valid_580793, JString, required = true,
                                 default = nil)
  if valid_580793 != nil:
    section.add "name", valid_580793
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580794 = query.getOrDefault("key")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "key", valid_580794
  var valid_580795 = query.getOrDefault("prettyPrint")
  valid_580795 = validateParameter(valid_580795, JBool, required = false,
                                 default = newJBool(true))
  if valid_580795 != nil:
    section.add "prettyPrint", valid_580795
  var valid_580796 = query.getOrDefault("oauth_token")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "oauth_token", valid_580796
  var valid_580797 = query.getOrDefault("$.xgafv")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = newJString("1"))
  if valid_580797 != nil:
    section.add "$.xgafv", valid_580797
  var valid_580798 = query.getOrDefault("alt")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = newJString("json"))
  if valid_580798 != nil:
    section.add "alt", valid_580798
  var valid_580799 = query.getOrDefault("uploadType")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "uploadType", valid_580799
  var valid_580800 = query.getOrDefault("quotaUser")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = nil)
  if valid_580800 != nil:
    section.add "quotaUser", valid_580800
  var valid_580801 = query.getOrDefault("callback")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = nil)
  if valid_580801 != nil:
    section.add "callback", valid_580801
  var valid_580802 = query.getOrDefault("fields")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = nil)
  if valid_580802 != nil:
    section.add "fields", valid_580802
  var valid_580803 = query.getOrDefault("access_token")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "access_token", valid_580803
  var valid_580804 = query.getOrDefault("upload_protocol")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "upload_protocol", valid_580804
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

proc call*(call_580806: Call_ContainerProjectsLocationsClustersSetLegacyAbac_580790;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_580806.validator(path, query, header, formData, body)
  let scheme = call_580806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580806.url(scheme.get, call_580806.host, call_580806.base,
                         call_580806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580806, url, valid)

proc call*(call_580807: Call_ContainerProjectsLocationsClustersSetLegacyAbac_580790;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set legacy abac.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580808 = newJObject()
  var query_580809 = newJObject()
  var body_580810 = newJObject()
  add(query_580809, "key", newJString(key))
  add(query_580809, "prettyPrint", newJBool(prettyPrint))
  add(query_580809, "oauth_token", newJString(oauthToken))
  add(query_580809, "$.xgafv", newJString(Xgafv))
  add(query_580809, "alt", newJString(alt))
  add(query_580809, "uploadType", newJString(uploadType))
  add(query_580809, "quotaUser", newJString(quotaUser))
  add(path_580808, "name", newJString(name))
  if body != nil:
    body_580810 = body
  add(query_580809, "callback", newJString(callback))
  add(query_580809, "fields", newJString(fields))
  add(query_580809, "access_token", newJString(accessToken))
  add(query_580809, "upload_protocol", newJString(uploadProtocol))
  result = call_580807.call(path_580808, query_580809, nil, nil, body_580810)

var containerProjectsLocationsClustersSetLegacyAbac* = Call_ContainerProjectsLocationsClustersSetLegacyAbac_580790(
    name: "containerProjectsLocationsClustersSetLegacyAbac",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLegacyAbac",
    validator: validate_ContainerProjectsLocationsClustersSetLegacyAbac_580791,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLegacyAbac_580792,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLocations_580811 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersSetLocations_580813(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLocations_580812(
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
  var valid_580814 = path.getOrDefault("name")
  valid_580814 = validateParameter(valid_580814, JString, required = true,
                                 default = nil)
  if valid_580814 != nil:
    section.add "name", valid_580814
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580815 = query.getOrDefault("key")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "key", valid_580815
  var valid_580816 = query.getOrDefault("prettyPrint")
  valid_580816 = validateParameter(valid_580816, JBool, required = false,
                                 default = newJBool(true))
  if valid_580816 != nil:
    section.add "prettyPrint", valid_580816
  var valid_580817 = query.getOrDefault("oauth_token")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = nil)
  if valid_580817 != nil:
    section.add "oauth_token", valid_580817
  var valid_580818 = query.getOrDefault("$.xgafv")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = newJString("1"))
  if valid_580818 != nil:
    section.add "$.xgafv", valid_580818
  var valid_580819 = query.getOrDefault("alt")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = newJString("json"))
  if valid_580819 != nil:
    section.add "alt", valid_580819
  var valid_580820 = query.getOrDefault("uploadType")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "uploadType", valid_580820
  var valid_580821 = query.getOrDefault("quotaUser")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = nil)
  if valid_580821 != nil:
    section.add "quotaUser", valid_580821
  var valid_580822 = query.getOrDefault("callback")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "callback", valid_580822
  var valid_580823 = query.getOrDefault("fields")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "fields", valid_580823
  var valid_580824 = query.getOrDefault("access_token")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "access_token", valid_580824
  var valid_580825 = query.getOrDefault("upload_protocol")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "upload_protocol", valid_580825
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

proc call*(call_580827: Call_ContainerProjectsLocationsClustersSetLocations_580811;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_580827.validator(path, query, header, formData, body)
  let scheme = call_580827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580827.url(scheme.get, call_580827.host, call_580827.base,
                         call_580827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580827, url, valid)

proc call*(call_580828: Call_ContainerProjectsLocationsClustersSetLocations_580811;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLocations
  ## Sets the locations for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set locations.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580829 = newJObject()
  var query_580830 = newJObject()
  var body_580831 = newJObject()
  add(query_580830, "key", newJString(key))
  add(query_580830, "prettyPrint", newJBool(prettyPrint))
  add(query_580830, "oauth_token", newJString(oauthToken))
  add(query_580830, "$.xgafv", newJString(Xgafv))
  add(query_580830, "alt", newJString(alt))
  add(query_580830, "uploadType", newJString(uploadType))
  add(query_580830, "quotaUser", newJString(quotaUser))
  add(path_580829, "name", newJString(name))
  if body != nil:
    body_580831 = body
  add(query_580830, "callback", newJString(callback))
  add(query_580830, "fields", newJString(fields))
  add(query_580830, "access_token", newJString(accessToken))
  add(query_580830, "upload_protocol", newJString(uploadProtocol))
  result = call_580828.call(path_580829, query_580830, nil, nil, body_580831)

var containerProjectsLocationsClustersSetLocations* = Call_ContainerProjectsLocationsClustersSetLocations_580811(
    name: "containerProjectsLocationsClustersSetLocations",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLocations",
    validator: validate_ContainerProjectsLocationsClustersSetLocations_580812,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLocations_580813,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLogging_580832 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersSetLogging_580834(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetLogging_580833(path: JsonNode;
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
  var valid_580835 = path.getOrDefault("name")
  valid_580835 = validateParameter(valid_580835, JString, required = true,
                                 default = nil)
  if valid_580835 != nil:
    section.add "name", valid_580835
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580836 = query.getOrDefault("key")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "key", valid_580836
  var valid_580837 = query.getOrDefault("prettyPrint")
  valid_580837 = validateParameter(valid_580837, JBool, required = false,
                                 default = newJBool(true))
  if valid_580837 != nil:
    section.add "prettyPrint", valid_580837
  var valid_580838 = query.getOrDefault("oauth_token")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = nil)
  if valid_580838 != nil:
    section.add "oauth_token", valid_580838
  var valid_580839 = query.getOrDefault("$.xgafv")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = newJString("1"))
  if valid_580839 != nil:
    section.add "$.xgafv", valid_580839
  var valid_580840 = query.getOrDefault("alt")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = newJString("json"))
  if valid_580840 != nil:
    section.add "alt", valid_580840
  var valid_580841 = query.getOrDefault("uploadType")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "uploadType", valid_580841
  var valid_580842 = query.getOrDefault("quotaUser")
  valid_580842 = validateParameter(valid_580842, JString, required = false,
                                 default = nil)
  if valid_580842 != nil:
    section.add "quotaUser", valid_580842
  var valid_580843 = query.getOrDefault("callback")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "callback", valid_580843
  var valid_580844 = query.getOrDefault("fields")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "fields", valid_580844
  var valid_580845 = query.getOrDefault("access_token")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "access_token", valid_580845
  var valid_580846 = query.getOrDefault("upload_protocol")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = nil)
  if valid_580846 != nil:
    section.add "upload_protocol", valid_580846
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

proc call*(call_580848: Call_ContainerProjectsLocationsClustersSetLogging_580832;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_580848.validator(path, query, header, formData, body)
  let scheme = call_580848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580848.url(scheme.get, call_580848.host, call_580848.base,
                         call_580848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580848, url, valid)

proc call*(call_580849: Call_ContainerProjectsLocationsClustersSetLogging_580832;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLogging
  ## Sets the logging service for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set logging.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580850 = newJObject()
  var query_580851 = newJObject()
  var body_580852 = newJObject()
  add(query_580851, "key", newJString(key))
  add(query_580851, "prettyPrint", newJBool(prettyPrint))
  add(query_580851, "oauth_token", newJString(oauthToken))
  add(query_580851, "$.xgafv", newJString(Xgafv))
  add(query_580851, "alt", newJString(alt))
  add(query_580851, "uploadType", newJString(uploadType))
  add(query_580851, "quotaUser", newJString(quotaUser))
  add(path_580850, "name", newJString(name))
  if body != nil:
    body_580852 = body
  add(query_580851, "callback", newJString(callback))
  add(query_580851, "fields", newJString(fields))
  add(query_580851, "access_token", newJString(accessToken))
  add(query_580851, "upload_protocol", newJString(uploadProtocol))
  result = call_580849.call(path_580850, query_580851, nil, nil, body_580852)

var containerProjectsLocationsClustersSetLogging* = Call_ContainerProjectsLocationsClustersSetLogging_580832(
    name: "containerProjectsLocationsClustersSetLogging",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLogging",
    validator: validate_ContainerProjectsLocationsClustersSetLogging_580833,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLogging_580834,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580853 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersSetMaintenancePolicy_580855(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_580854(
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
  var valid_580856 = path.getOrDefault("name")
  valid_580856 = validateParameter(valid_580856, JString, required = true,
                                 default = nil)
  if valid_580856 != nil:
    section.add "name", valid_580856
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580857 = query.getOrDefault("key")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "key", valid_580857
  var valid_580858 = query.getOrDefault("prettyPrint")
  valid_580858 = validateParameter(valid_580858, JBool, required = false,
                                 default = newJBool(true))
  if valid_580858 != nil:
    section.add "prettyPrint", valid_580858
  var valid_580859 = query.getOrDefault("oauth_token")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "oauth_token", valid_580859
  var valid_580860 = query.getOrDefault("$.xgafv")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = newJString("1"))
  if valid_580860 != nil:
    section.add "$.xgafv", valid_580860
  var valid_580861 = query.getOrDefault("alt")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = newJString("json"))
  if valid_580861 != nil:
    section.add "alt", valid_580861
  var valid_580862 = query.getOrDefault("uploadType")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = nil)
  if valid_580862 != nil:
    section.add "uploadType", valid_580862
  var valid_580863 = query.getOrDefault("quotaUser")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "quotaUser", valid_580863
  var valid_580864 = query.getOrDefault("callback")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "callback", valid_580864
  var valid_580865 = query.getOrDefault("fields")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "fields", valid_580865
  var valid_580866 = query.getOrDefault("access_token")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "access_token", valid_580866
  var valid_580867 = query.getOrDefault("upload_protocol")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = nil)
  if valid_580867 != nil:
    section.add "upload_protocol", valid_580867
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

proc call*(call_580869: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580853;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_580869.validator(path, query, header, formData, body)
  let scheme = call_580869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580869.url(scheme.get, call_580869.host, call_580869.base,
                         call_580869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580869, url, valid)

proc call*(call_580870: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580853;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMaintenancePolicy
  ## Sets the maintenance policy for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set maintenance
  ## policy.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580871 = newJObject()
  var query_580872 = newJObject()
  var body_580873 = newJObject()
  add(query_580872, "key", newJString(key))
  add(query_580872, "prettyPrint", newJBool(prettyPrint))
  add(query_580872, "oauth_token", newJString(oauthToken))
  add(query_580872, "$.xgafv", newJString(Xgafv))
  add(query_580872, "alt", newJString(alt))
  add(query_580872, "uploadType", newJString(uploadType))
  add(query_580872, "quotaUser", newJString(quotaUser))
  add(path_580871, "name", newJString(name))
  if body != nil:
    body_580873 = body
  add(query_580872, "callback", newJString(callback))
  add(query_580872, "fields", newJString(fields))
  add(query_580872, "access_token", newJString(accessToken))
  add(query_580872, "upload_protocol", newJString(uploadProtocol))
  result = call_580870.call(path_580871, query_580872, nil, nil, body_580873)

var containerProjectsLocationsClustersSetMaintenancePolicy* = Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580853(
    name: "containerProjectsLocationsClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMaintenancePolicy",
    validator: validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_580854,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMaintenancePolicy_580855,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580874 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersNodePoolsSetManagement_580876(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_580875(
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
  var valid_580877 = path.getOrDefault("name")
  valid_580877 = validateParameter(valid_580877, JString, required = true,
                                 default = nil)
  if valid_580877 != nil:
    section.add "name", valid_580877
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580878 = query.getOrDefault("key")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = nil)
  if valid_580878 != nil:
    section.add "key", valid_580878
  var valid_580879 = query.getOrDefault("prettyPrint")
  valid_580879 = validateParameter(valid_580879, JBool, required = false,
                                 default = newJBool(true))
  if valid_580879 != nil:
    section.add "prettyPrint", valid_580879
  var valid_580880 = query.getOrDefault("oauth_token")
  valid_580880 = validateParameter(valid_580880, JString, required = false,
                                 default = nil)
  if valid_580880 != nil:
    section.add "oauth_token", valid_580880
  var valid_580881 = query.getOrDefault("$.xgafv")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = newJString("1"))
  if valid_580881 != nil:
    section.add "$.xgafv", valid_580881
  var valid_580882 = query.getOrDefault("alt")
  valid_580882 = validateParameter(valid_580882, JString, required = false,
                                 default = newJString("json"))
  if valid_580882 != nil:
    section.add "alt", valid_580882
  var valid_580883 = query.getOrDefault("uploadType")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "uploadType", valid_580883
  var valid_580884 = query.getOrDefault("quotaUser")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = nil)
  if valid_580884 != nil:
    section.add "quotaUser", valid_580884
  var valid_580885 = query.getOrDefault("callback")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = nil)
  if valid_580885 != nil:
    section.add "callback", valid_580885
  var valid_580886 = query.getOrDefault("fields")
  valid_580886 = validateParameter(valid_580886, JString, required = false,
                                 default = nil)
  if valid_580886 != nil:
    section.add "fields", valid_580886
  var valid_580887 = query.getOrDefault("access_token")
  valid_580887 = validateParameter(valid_580887, JString, required = false,
                                 default = nil)
  if valid_580887 != nil:
    section.add "access_token", valid_580887
  var valid_580888 = query.getOrDefault("upload_protocol")
  valid_580888 = validateParameter(valid_580888, JString, required = false,
                                 default = nil)
  if valid_580888 != nil:
    section.add "upload_protocol", valid_580888
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

proc call*(call_580890: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580874;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_580890.validator(path, query, header, formData, body)
  let scheme = call_580890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580890.url(scheme.get, call_580890.host, call_580890.base,
                         call_580890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580890, url, valid)

proc call*(call_580891: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580874;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## management properties. Specified in the format
  ## 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580892 = newJObject()
  var query_580893 = newJObject()
  var body_580894 = newJObject()
  add(query_580893, "key", newJString(key))
  add(query_580893, "prettyPrint", newJBool(prettyPrint))
  add(query_580893, "oauth_token", newJString(oauthToken))
  add(query_580893, "$.xgafv", newJString(Xgafv))
  add(query_580893, "alt", newJString(alt))
  add(query_580893, "uploadType", newJString(uploadType))
  add(query_580893, "quotaUser", newJString(quotaUser))
  add(path_580892, "name", newJString(name))
  if body != nil:
    body_580894 = body
  add(query_580893, "callback", newJString(callback))
  add(query_580893, "fields", newJString(fields))
  add(query_580893, "access_token", newJString(accessToken))
  add(query_580893, "upload_protocol", newJString(uploadProtocol))
  result = call_580891.call(path_580892, query_580893, nil, nil, body_580894)

var containerProjectsLocationsClustersNodePoolsSetManagement* = Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580874(
    name: "containerProjectsLocationsClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setManagement", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_580875,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetManagement_580876,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMasterAuth_580895 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersSetMasterAuth_580897(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMasterAuth_580896(
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
  var valid_580898 = path.getOrDefault("name")
  valid_580898 = validateParameter(valid_580898, JString, required = true,
                                 default = nil)
  if valid_580898 != nil:
    section.add "name", valid_580898
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580899 = query.getOrDefault("key")
  valid_580899 = validateParameter(valid_580899, JString, required = false,
                                 default = nil)
  if valid_580899 != nil:
    section.add "key", valid_580899
  var valid_580900 = query.getOrDefault("prettyPrint")
  valid_580900 = validateParameter(valid_580900, JBool, required = false,
                                 default = newJBool(true))
  if valid_580900 != nil:
    section.add "prettyPrint", valid_580900
  var valid_580901 = query.getOrDefault("oauth_token")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = nil)
  if valid_580901 != nil:
    section.add "oauth_token", valid_580901
  var valid_580902 = query.getOrDefault("$.xgafv")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = newJString("1"))
  if valid_580902 != nil:
    section.add "$.xgafv", valid_580902
  var valid_580903 = query.getOrDefault("alt")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = newJString("json"))
  if valid_580903 != nil:
    section.add "alt", valid_580903
  var valid_580904 = query.getOrDefault("uploadType")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "uploadType", valid_580904
  var valid_580905 = query.getOrDefault("quotaUser")
  valid_580905 = validateParameter(valid_580905, JString, required = false,
                                 default = nil)
  if valid_580905 != nil:
    section.add "quotaUser", valid_580905
  var valid_580906 = query.getOrDefault("callback")
  valid_580906 = validateParameter(valid_580906, JString, required = false,
                                 default = nil)
  if valid_580906 != nil:
    section.add "callback", valid_580906
  var valid_580907 = query.getOrDefault("fields")
  valid_580907 = validateParameter(valid_580907, JString, required = false,
                                 default = nil)
  if valid_580907 != nil:
    section.add "fields", valid_580907
  var valid_580908 = query.getOrDefault("access_token")
  valid_580908 = validateParameter(valid_580908, JString, required = false,
                                 default = nil)
  if valid_580908 != nil:
    section.add "access_token", valid_580908
  var valid_580909 = query.getOrDefault("upload_protocol")
  valid_580909 = validateParameter(valid_580909, JString, required = false,
                                 default = nil)
  if valid_580909 != nil:
    section.add "upload_protocol", valid_580909
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

proc call*(call_580911: Call_ContainerProjectsLocationsClustersSetMasterAuth_580895;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_580911.validator(path, query, header, formData, body)
  let scheme = call_580911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580911.url(scheme.get, call_580911.host, call_580911.base,
                         call_580911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580911, url, valid)

proc call*(call_580912: Call_ContainerProjectsLocationsClustersSetMasterAuth_580895;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMasterAuth
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set auth.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580913 = newJObject()
  var query_580914 = newJObject()
  var body_580915 = newJObject()
  add(query_580914, "key", newJString(key))
  add(query_580914, "prettyPrint", newJBool(prettyPrint))
  add(query_580914, "oauth_token", newJString(oauthToken))
  add(query_580914, "$.xgafv", newJString(Xgafv))
  add(query_580914, "alt", newJString(alt))
  add(query_580914, "uploadType", newJString(uploadType))
  add(query_580914, "quotaUser", newJString(quotaUser))
  add(path_580913, "name", newJString(name))
  if body != nil:
    body_580915 = body
  add(query_580914, "callback", newJString(callback))
  add(query_580914, "fields", newJString(fields))
  add(query_580914, "access_token", newJString(accessToken))
  add(query_580914, "upload_protocol", newJString(uploadProtocol))
  result = call_580912.call(path_580913, query_580914, nil, nil, body_580915)

var containerProjectsLocationsClustersSetMasterAuth* = Call_ContainerProjectsLocationsClustersSetMasterAuth_580895(
    name: "containerProjectsLocationsClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMasterAuth",
    validator: validate_ContainerProjectsLocationsClustersSetMasterAuth_580896,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMasterAuth_580897,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMonitoring_580916 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersSetMonitoring_580918(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetMonitoring_580917(
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
  var valid_580919 = path.getOrDefault("name")
  valid_580919 = validateParameter(valid_580919, JString, required = true,
                                 default = nil)
  if valid_580919 != nil:
    section.add "name", valid_580919
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580920 = query.getOrDefault("key")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = nil)
  if valid_580920 != nil:
    section.add "key", valid_580920
  var valid_580921 = query.getOrDefault("prettyPrint")
  valid_580921 = validateParameter(valid_580921, JBool, required = false,
                                 default = newJBool(true))
  if valid_580921 != nil:
    section.add "prettyPrint", valid_580921
  var valid_580922 = query.getOrDefault("oauth_token")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = nil)
  if valid_580922 != nil:
    section.add "oauth_token", valid_580922
  var valid_580923 = query.getOrDefault("$.xgafv")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = newJString("1"))
  if valid_580923 != nil:
    section.add "$.xgafv", valid_580923
  var valid_580924 = query.getOrDefault("alt")
  valid_580924 = validateParameter(valid_580924, JString, required = false,
                                 default = newJString("json"))
  if valid_580924 != nil:
    section.add "alt", valid_580924
  var valid_580925 = query.getOrDefault("uploadType")
  valid_580925 = validateParameter(valid_580925, JString, required = false,
                                 default = nil)
  if valid_580925 != nil:
    section.add "uploadType", valid_580925
  var valid_580926 = query.getOrDefault("quotaUser")
  valid_580926 = validateParameter(valid_580926, JString, required = false,
                                 default = nil)
  if valid_580926 != nil:
    section.add "quotaUser", valid_580926
  var valid_580927 = query.getOrDefault("callback")
  valid_580927 = validateParameter(valid_580927, JString, required = false,
                                 default = nil)
  if valid_580927 != nil:
    section.add "callback", valid_580927
  var valid_580928 = query.getOrDefault("fields")
  valid_580928 = validateParameter(valid_580928, JString, required = false,
                                 default = nil)
  if valid_580928 != nil:
    section.add "fields", valid_580928
  var valid_580929 = query.getOrDefault("access_token")
  valid_580929 = validateParameter(valid_580929, JString, required = false,
                                 default = nil)
  if valid_580929 != nil:
    section.add "access_token", valid_580929
  var valid_580930 = query.getOrDefault("upload_protocol")
  valid_580930 = validateParameter(valid_580930, JString, required = false,
                                 default = nil)
  if valid_580930 != nil:
    section.add "upload_protocol", valid_580930
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

proc call*(call_580932: Call_ContainerProjectsLocationsClustersSetMonitoring_580916;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_580932.validator(path, query, header, formData, body)
  let scheme = call_580932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580932.url(scheme.get, call_580932.host, call_580932.base,
                         call_580932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580932, url, valid)

proc call*(call_580933: Call_ContainerProjectsLocationsClustersSetMonitoring_580916;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMonitoring
  ## Sets the monitoring service for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to set monitoring.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580934 = newJObject()
  var query_580935 = newJObject()
  var body_580936 = newJObject()
  add(query_580935, "key", newJString(key))
  add(query_580935, "prettyPrint", newJBool(prettyPrint))
  add(query_580935, "oauth_token", newJString(oauthToken))
  add(query_580935, "$.xgafv", newJString(Xgafv))
  add(query_580935, "alt", newJString(alt))
  add(query_580935, "uploadType", newJString(uploadType))
  add(query_580935, "quotaUser", newJString(quotaUser))
  add(path_580934, "name", newJString(name))
  if body != nil:
    body_580936 = body
  add(query_580935, "callback", newJString(callback))
  add(query_580935, "fields", newJString(fields))
  add(query_580935, "access_token", newJString(accessToken))
  add(query_580935, "upload_protocol", newJString(uploadProtocol))
  result = call_580933.call(path_580934, query_580935, nil, nil, body_580936)

var containerProjectsLocationsClustersSetMonitoring* = Call_ContainerProjectsLocationsClustersSetMonitoring_580916(
    name: "containerProjectsLocationsClustersSetMonitoring",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMonitoring",
    validator: validate_ContainerProjectsLocationsClustersSetMonitoring_580917,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMonitoring_580918,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetNetworkPolicy_580937 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersSetNetworkPolicy_580939(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetNetworkPolicy_580938(
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
  var valid_580940 = path.getOrDefault("name")
  valid_580940 = validateParameter(valid_580940, JString, required = true,
                                 default = nil)
  if valid_580940 != nil:
    section.add "name", valid_580940
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580941 = query.getOrDefault("key")
  valid_580941 = validateParameter(valid_580941, JString, required = false,
                                 default = nil)
  if valid_580941 != nil:
    section.add "key", valid_580941
  var valid_580942 = query.getOrDefault("prettyPrint")
  valid_580942 = validateParameter(valid_580942, JBool, required = false,
                                 default = newJBool(true))
  if valid_580942 != nil:
    section.add "prettyPrint", valid_580942
  var valid_580943 = query.getOrDefault("oauth_token")
  valid_580943 = validateParameter(valid_580943, JString, required = false,
                                 default = nil)
  if valid_580943 != nil:
    section.add "oauth_token", valid_580943
  var valid_580944 = query.getOrDefault("$.xgafv")
  valid_580944 = validateParameter(valid_580944, JString, required = false,
                                 default = newJString("1"))
  if valid_580944 != nil:
    section.add "$.xgafv", valid_580944
  var valid_580945 = query.getOrDefault("alt")
  valid_580945 = validateParameter(valid_580945, JString, required = false,
                                 default = newJString("json"))
  if valid_580945 != nil:
    section.add "alt", valid_580945
  var valid_580946 = query.getOrDefault("uploadType")
  valid_580946 = validateParameter(valid_580946, JString, required = false,
                                 default = nil)
  if valid_580946 != nil:
    section.add "uploadType", valid_580946
  var valid_580947 = query.getOrDefault("quotaUser")
  valid_580947 = validateParameter(valid_580947, JString, required = false,
                                 default = nil)
  if valid_580947 != nil:
    section.add "quotaUser", valid_580947
  var valid_580948 = query.getOrDefault("callback")
  valid_580948 = validateParameter(valid_580948, JString, required = false,
                                 default = nil)
  if valid_580948 != nil:
    section.add "callback", valid_580948
  var valid_580949 = query.getOrDefault("fields")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = nil)
  if valid_580949 != nil:
    section.add "fields", valid_580949
  var valid_580950 = query.getOrDefault("access_token")
  valid_580950 = validateParameter(valid_580950, JString, required = false,
                                 default = nil)
  if valid_580950 != nil:
    section.add "access_token", valid_580950
  var valid_580951 = query.getOrDefault("upload_protocol")
  valid_580951 = validateParameter(valid_580951, JString, required = false,
                                 default = nil)
  if valid_580951 != nil:
    section.add "upload_protocol", valid_580951
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

proc call*(call_580953: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_580937;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_580953.validator(path, query, header, formData, body)
  let scheme = call_580953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580953.url(scheme.get, call_580953.host, call_580953.base,
                         call_580953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580953, url, valid)

proc call*(call_580954: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_580937;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetNetworkPolicy
  ## Enables or disables Network Policy for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking
  ## policy. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580955 = newJObject()
  var query_580956 = newJObject()
  var body_580957 = newJObject()
  add(query_580956, "key", newJString(key))
  add(query_580956, "prettyPrint", newJBool(prettyPrint))
  add(query_580956, "oauth_token", newJString(oauthToken))
  add(query_580956, "$.xgafv", newJString(Xgafv))
  add(query_580956, "alt", newJString(alt))
  add(query_580956, "uploadType", newJString(uploadType))
  add(query_580956, "quotaUser", newJString(quotaUser))
  add(path_580955, "name", newJString(name))
  if body != nil:
    body_580957 = body
  add(query_580956, "callback", newJString(callback))
  add(query_580956, "fields", newJString(fields))
  add(query_580956, "access_token", newJString(accessToken))
  add(query_580956, "upload_protocol", newJString(uploadProtocol))
  result = call_580954.call(path_580955, query_580956, nil, nil, body_580957)

var containerProjectsLocationsClustersSetNetworkPolicy* = Call_ContainerProjectsLocationsClustersSetNetworkPolicy_580937(
    name: "containerProjectsLocationsClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setNetworkPolicy",
    validator: validate_ContainerProjectsLocationsClustersSetNetworkPolicy_580938,
    base: "/", url: url_ContainerProjectsLocationsClustersSetNetworkPolicy_580939,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetResourceLabels_580958 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersSetResourceLabels_580960(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersSetResourceLabels_580959(
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
  var valid_580961 = path.getOrDefault("name")
  valid_580961 = validateParameter(valid_580961, JString, required = true,
                                 default = nil)
  if valid_580961 != nil:
    section.add "name", valid_580961
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580962 = query.getOrDefault("key")
  valid_580962 = validateParameter(valid_580962, JString, required = false,
                                 default = nil)
  if valid_580962 != nil:
    section.add "key", valid_580962
  var valid_580963 = query.getOrDefault("prettyPrint")
  valid_580963 = validateParameter(valid_580963, JBool, required = false,
                                 default = newJBool(true))
  if valid_580963 != nil:
    section.add "prettyPrint", valid_580963
  var valid_580964 = query.getOrDefault("oauth_token")
  valid_580964 = validateParameter(valid_580964, JString, required = false,
                                 default = nil)
  if valid_580964 != nil:
    section.add "oauth_token", valid_580964
  var valid_580965 = query.getOrDefault("$.xgafv")
  valid_580965 = validateParameter(valid_580965, JString, required = false,
                                 default = newJString("1"))
  if valid_580965 != nil:
    section.add "$.xgafv", valid_580965
  var valid_580966 = query.getOrDefault("alt")
  valid_580966 = validateParameter(valid_580966, JString, required = false,
                                 default = newJString("json"))
  if valid_580966 != nil:
    section.add "alt", valid_580966
  var valid_580967 = query.getOrDefault("uploadType")
  valid_580967 = validateParameter(valid_580967, JString, required = false,
                                 default = nil)
  if valid_580967 != nil:
    section.add "uploadType", valid_580967
  var valid_580968 = query.getOrDefault("quotaUser")
  valid_580968 = validateParameter(valid_580968, JString, required = false,
                                 default = nil)
  if valid_580968 != nil:
    section.add "quotaUser", valid_580968
  var valid_580969 = query.getOrDefault("callback")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = nil)
  if valid_580969 != nil:
    section.add "callback", valid_580969
  var valid_580970 = query.getOrDefault("fields")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "fields", valid_580970
  var valid_580971 = query.getOrDefault("access_token")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = nil)
  if valid_580971 != nil:
    section.add "access_token", valid_580971
  var valid_580972 = query.getOrDefault("upload_protocol")
  valid_580972 = validateParameter(valid_580972, JString, required = false,
                                 default = nil)
  if valid_580972 != nil:
    section.add "upload_protocol", valid_580972
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

proc call*(call_580974: Call_ContainerProjectsLocationsClustersSetResourceLabels_580958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_580974.validator(path, query, header, formData, body)
  let scheme = call_580974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580974.url(scheme.get, call_580974.host, call_580974.base,
                         call_580974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580974, url, valid)

proc call*(call_580975: Call_ContainerProjectsLocationsClustersSetResourceLabels_580958;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetResourceLabels
  ## Sets labels on a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set labels.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580976 = newJObject()
  var query_580977 = newJObject()
  var body_580978 = newJObject()
  add(query_580977, "key", newJString(key))
  add(query_580977, "prettyPrint", newJBool(prettyPrint))
  add(query_580977, "oauth_token", newJString(oauthToken))
  add(query_580977, "$.xgafv", newJString(Xgafv))
  add(query_580977, "alt", newJString(alt))
  add(query_580977, "uploadType", newJString(uploadType))
  add(query_580977, "quotaUser", newJString(quotaUser))
  add(path_580976, "name", newJString(name))
  if body != nil:
    body_580978 = body
  add(query_580977, "callback", newJString(callback))
  add(query_580977, "fields", newJString(fields))
  add(query_580977, "access_token", newJString(accessToken))
  add(query_580977, "upload_protocol", newJString(uploadProtocol))
  result = call_580975.call(path_580976, query_580977, nil, nil, body_580978)

var containerProjectsLocationsClustersSetResourceLabels* = Call_ContainerProjectsLocationsClustersSetResourceLabels_580958(
    name: "containerProjectsLocationsClustersSetResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setResourceLabels",
    validator: validate_ContainerProjectsLocationsClustersSetResourceLabels_580959,
    base: "/", url: url_ContainerProjectsLocationsClustersSetResourceLabels_580960,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetSize_580979 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersNodePoolsSetSize_580981(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsSetSize_580980(
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
  var valid_580982 = path.getOrDefault("name")
  valid_580982 = validateParameter(valid_580982, JString, required = true,
                                 default = nil)
  if valid_580982 != nil:
    section.add "name", valid_580982
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580983 = query.getOrDefault("key")
  valid_580983 = validateParameter(valid_580983, JString, required = false,
                                 default = nil)
  if valid_580983 != nil:
    section.add "key", valid_580983
  var valid_580984 = query.getOrDefault("prettyPrint")
  valid_580984 = validateParameter(valid_580984, JBool, required = false,
                                 default = newJBool(true))
  if valid_580984 != nil:
    section.add "prettyPrint", valid_580984
  var valid_580985 = query.getOrDefault("oauth_token")
  valid_580985 = validateParameter(valid_580985, JString, required = false,
                                 default = nil)
  if valid_580985 != nil:
    section.add "oauth_token", valid_580985
  var valid_580986 = query.getOrDefault("$.xgafv")
  valid_580986 = validateParameter(valid_580986, JString, required = false,
                                 default = newJString("1"))
  if valid_580986 != nil:
    section.add "$.xgafv", valid_580986
  var valid_580987 = query.getOrDefault("alt")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = newJString("json"))
  if valid_580987 != nil:
    section.add "alt", valid_580987
  var valid_580988 = query.getOrDefault("uploadType")
  valid_580988 = validateParameter(valid_580988, JString, required = false,
                                 default = nil)
  if valid_580988 != nil:
    section.add "uploadType", valid_580988
  var valid_580989 = query.getOrDefault("quotaUser")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "quotaUser", valid_580989
  var valid_580990 = query.getOrDefault("callback")
  valid_580990 = validateParameter(valid_580990, JString, required = false,
                                 default = nil)
  if valid_580990 != nil:
    section.add "callback", valid_580990
  var valid_580991 = query.getOrDefault("fields")
  valid_580991 = validateParameter(valid_580991, JString, required = false,
                                 default = nil)
  if valid_580991 != nil:
    section.add "fields", valid_580991
  var valid_580992 = query.getOrDefault("access_token")
  valid_580992 = validateParameter(valid_580992, JString, required = false,
                                 default = nil)
  if valid_580992 != nil:
    section.add "access_token", valid_580992
  var valid_580993 = query.getOrDefault("upload_protocol")
  valid_580993 = validateParameter(valid_580993, JString, required = false,
                                 default = nil)
  if valid_580993 != nil:
    section.add "upload_protocol", valid_580993
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

proc call*(call_580995: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_580979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_580995.validator(path, query, header, formData, body)
  let scheme = call_580995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580995.url(scheme.get, call_580995.host, call_580995.base,
                         call_580995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580995, url, valid)

proc call*(call_580996: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_580979;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetSize
  ## Sets the size for a specific node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to set
  ## size.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580997 = newJObject()
  var query_580998 = newJObject()
  var body_580999 = newJObject()
  add(query_580998, "key", newJString(key))
  add(query_580998, "prettyPrint", newJBool(prettyPrint))
  add(query_580998, "oauth_token", newJString(oauthToken))
  add(query_580998, "$.xgafv", newJString(Xgafv))
  add(query_580998, "alt", newJString(alt))
  add(query_580998, "uploadType", newJString(uploadType))
  add(query_580998, "quotaUser", newJString(quotaUser))
  add(path_580997, "name", newJString(name))
  if body != nil:
    body_580999 = body
  add(query_580998, "callback", newJString(callback))
  add(query_580998, "fields", newJString(fields))
  add(query_580998, "access_token", newJString(accessToken))
  add(query_580998, "upload_protocol", newJString(uploadProtocol))
  result = call_580996.call(path_580997, query_580998, nil, nil, body_580999)

var containerProjectsLocationsClustersNodePoolsSetSize* = Call_ContainerProjectsLocationsClustersNodePoolsSetSize_580979(
    name: "containerProjectsLocationsClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setSize",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsSetSize_580980,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetSize_580981,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersStartIpRotation_581000 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersStartIpRotation_581002(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersStartIpRotation_581001(
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
  var valid_581003 = path.getOrDefault("name")
  valid_581003 = validateParameter(valid_581003, JString, required = true,
                                 default = nil)
  if valid_581003 != nil:
    section.add "name", valid_581003
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_581004 = query.getOrDefault("key")
  valid_581004 = validateParameter(valid_581004, JString, required = false,
                                 default = nil)
  if valid_581004 != nil:
    section.add "key", valid_581004
  var valid_581005 = query.getOrDefault("prettyPrint")
  valid_581005 = validateParameter(valid_581005, JBool, required = false,
                                 default = newJBool(true))
  if valid_581005 != nil:
    section.add "prettyPrint", valid_581005
  var valid_581006 = query.getOrDefault("oauth_token")
  valid_581006 = validateParameter(valid_581006, JString, required = false,
                                 default = nil)
  if valid_581006 != nil:
    section.add "oauth_token", valid_581006
  var valid_581007 = query.getOrDefault("$.xgafv")
  valid_581007 = validateParameter(valid_581007, JString, required = false,
                                 default = newJString("1"))
  if valid_581007 != nil:
    section.add "$.xgafv", valid_581007
  var valid_581008 = query.getOrDefault("alt")
  valid_581008 = validateParameter(valid_581008, JString, required = false,
                                 default = newJString("json"))
  if valid_581008 != nil:
    section.add "alt", valid_581008
  var valid_581009 = query.getOrDefault("uploadType")
  valid_581009 = validateParameter(valid_581009, JString, required = false,
                                 default = nil)
  if valid_581009 != nil:
    section.add "uploadType", valid_581009
  var valid_581010 = query.getOrDefault("quotaUser")
  valid_581010 = validateParameter(valid_581010, JString, required = false,
                                 default = nil)
  if valid_581010 != nil:
    section.add "quotaUser", valid_581010
  var valid_581011 = query.getOrDefault("callback")
  valid_581011 = validateParameter(valid_581011, JString, required = false,
                                 default = nil)
  if valid_581011 != nil:
    section.add "callback", valid_581011
  var valid_581012 = query.getOrDefault("fields")
  valid_581012 = validateParameter(valid_581012, JString, required = false,
                                 default = nil)
  if valid_581012 != nil:
    section.add "fields", valid_581012
  var valid_581013 = query.getOrDefault("access_token")
  valid_581013 = validateParameter(valid_581013, JString, required = false,
                                 default = nil)
  if valid_581013 != nil:
    section.add "access_token", valid_581013
  var valid_581014 = query.getOrDefault("upload_protocol")
  valid_581014 = validateParameter(valid_581014, JString, required = false,
                                 default = nil)
  if valid_581014 != nil:
    section.add "upload_protocol", valid_581014
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

proc call*(call_581016: Call_ContainerProjectsLocationsClustersStartIpRotation_581000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_581016.validator(path, query, header, formData, body)
  let scheme = call_581016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581016.url(scheme.get, call_581016.host, call_581016.base,
                         call_581016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581016, url, valid)

proc call*(call_581017: Call_ContainerProjectsLocationsClustersStartIpRotation_581000;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersStartIpRotation
  ## Starts master IP rotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP
  ## rotation. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_581018 = newJObject()
  var query_581019 = newJObject()
  var body_581020 = newJObject()
  add(query_581019, "key", newJString(key))
  add(query_581019, "prettyPrint", newJBool(prettyPrint))
  add(query_581019, "oauth_token", newJString(oauthToken))
  add(query_581019, "$.xgafv", newJString(Xgafv))
  add(query_581019, "alt", newJString(alt))
  add(query_581019, "uploadType", newJString(uploadType))
  add(query_581019, "quotaUser", newJString(quotaUser))
  add(path_581018, "name", newJString(name))
  if body != nil:
    body_581020 = body
  add(query_581019, "callback", newJString(callback))
  add(query_581019, "fields", newJString(fields))
  add(query_581019, "access_token", newJString(accessToken))
  add(query_581019, "upload_protocol", newJString(uploadProtocol))
  result = call_581017.call(path_581018, query_581019, nil, nil, body_581020)

var containerProjectsLocationsClustersStartIpRotation* = Call_ContainerProjectsLocationsClustersStartIpRotation_581000(
    name: "containerProjectsLocationsClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:startIpRotation",
    validator: validate_ContainerProjectsLocationsClustersStartIpRotation_581001,
    base: "/", url: url_ContainerProjectsLocationsClustersStartIpRotation_581002,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersUpdateMaster_581021 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersUpdateMaster_581023(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersUpdateMaster_581022(
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
  var valid_581024 = path.getOrDefault("name")
  valid_581024 = validateParameter(valid_581024, JString, required = true,
                                 default = nil)
  if valid_581024 != nil:
    section.add "name", valid_581024
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_581025 = query.getOrDefault("key")
  valid_581025 = validateParameter(valid_581025, JString, required = false,
                                 default = nil)
  if valid_581025 != nil:
    section.add "key", valid_581025
  var valid_581026 = query.getOrDefault("prettyPrint")
  valid_581026 = validateParameter(valid_581026, JBool, required = false,
                                 default = newJBool(true))
  if valid_581026 != nil:
    section.add "prettyPrint", valid_581026
  var valid_581027 = query.getOrDefault("oauth_token")
  valid_581027 = validateParameter(valid_581027, JString, required = false,
                                 default = nil)
  if valid_581027 != nil:
    section.add "oauth_token", valid_581027
  var valid_581028 = query.getOrDefault("$.xgafv")
  valid_581028 = validateParameter(valid_581028, JString, required = false,
                                 default = newJString("1"))
  if valid_581028 != nil:
    section.add "$.xgafv", valid_581028
  var valid_581029 = query.getOrDefault("alt")
  valid_581029 = validateParameter(valid_581029, JString, required = false,
                                 default = newJString("json"))
  if valid_581029 != nil:
    section.add "alt", valid_581029
  var valid_581030 = query.getOrDefault("uploadType")
  valid_581030 = validateParameter(valid_581030, JString, required = false,
                                 default = nil)
  if valid_581030 != nil:
    section.add "uploadType", valid_581030
  var valid_581031 = query.getOrDefault("quotaUser")
  valid_581031 = validateParameter(valid_581031, JString, required = false,
                                 default = nil)
  if valid_581031 != nil:
    section.add "quotaUser", valid_581031
  var valid_581032 = query.getOrDefault("callback")
  valid_581032 = validateParameter(valid_581032, JString, required = false,
                                 default = nil)
  if valid_581032 != nil:
    section.add "callback", valid_581032
  var valid_581033 = query.getOrDefault("fields")
  valid_581033 = validateParameter(valid_581033, JString, required = false,
                                 default = nil)
  if valid_581033 != nil:
    section.add "fields", valid_581033
  var valid_581034 = query.getOrDefault("access_token")
  valid_581034 = validateParameter(valid_581034, JString, required = false,
                                 default = nil)
  if valid_581034 != nil:
    section.add "access_token", valid_581034
  var valid_581035 = query.getOrDefault("upload_protocol")
  valid_581035 = validateParameter(valid_581035, JString, required = false,
                                 default = nil)
  if valid_581035 != nil:
    section.add "upload_protocol", valid_581035
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

proc call*(call_581037: Call_ContainerProjectsLocationsClustersUpdateMaster_581021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_581037.validator(path, query, header, formData, body)
  let scheme = call_581037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581037.url(scheme.get, call_581037.host, call_581037.base,
                         call_581037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581037, url, valid)

proc call*(call_581038: Call_ContainerProjectsLocationsClustersUpdateMaster_581021;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersUpdateMaster
  ## Updates the master for a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster) of the cluster to update.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_581039 = newJObject()
  var query_581040 = newJObject()
  var body_581041 = newJObject()
  add(query_581040, "key", newJString(key))
  add(query_581040, "prettyPrint", newJBool(prettyPrint))
  add(query_581040, "oauth_token", newJString(oauthToken))
  add(query_581040, "$.xgafv", newJString(Xgafv))
  add(query_581040, "alt", newJString(alt))
  add(query_581040, "uploadType", newJString(uploadType))
  add(query_581040, "quotaUser", newJString(quotaUser))
  add(path_581039, "name", newJString(name))
  if body != nil:
    body_581041 = body
  add(query_581040, "callback", newJString(callback))
  add(query_581040, "fields", newJString(fields))
  add(query_581040, "access_token", newJString(accessToken))
  add(query_581040, "upload_protocol", newJString(uploadProtocol))
  result = call_581038.call(path_581039, query_581040, nil, nil, body_581041)

var containerProjectsLocationsClustersUpdateMaster* = Call_ContainerProjectsLocationsClustersUpdateMaster_581021(
    name: "containerProjectsLocationsClustersUpdateMaster",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:updateMaster",
    validator: validate_ContainerProjectsLocationsClustersUpdateMaster_581022,
    base: "/", url: url_ContainerProjectsLocationsClustersUpdateMaster_581023,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581042 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581044(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581043(
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
  var valid_581045 = path.getOrDefault("parent")
  valid_581045 = validateParameter(valid_581045, JString, required = true,
                                 default = nil)
  if valid_581045 != nil:
    section.add "parent", valid_581045
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_581046 = query.getOrDefault("key")
  valid_581046 = validateParameter(valid_581046, JString, required = false,
                                 default = nil)
  if valid_581046 != nil:
    section.add "key", valid_581046
  var valid_581047 = query.getOrDefault("prettyPrint")
  valid_581047 = validateParameter(valid_581047, JBool, required = false,
                                 default = newJBool(true))
  if valid_581047 != nil:
    section.add "prettyPrint", valid_581047
  var valid_581048 = query.getOrDefault("oauth_token")
  valid_581048 = validateParameter(valid_581048, JString, required = false,
                                 default = nil)
  if valid_581048 != nil:
    section.add "oauth_token", valid_581048
  var valid_581049 = query.getOrDefault("$.xgafv")
  valid_581049 = validateParameter(valid_581049, JString, required = false,
                                 default = newJString("1"))
  if valid_581049 != nil:
    section.add "$.xgafv", valid_581049
  var valid_581050 = query.getOrDefault("alt")
  valid_581050 = validateParameter(valid_581050, JString, required = false,
                                 default = newJString("json"))
  if valid_581050 != nil:
    section.add "alt", valid_581050
  var valid_581051 = query.getOrDefault("uploadType")
  valid_581051 = validateParameter(valid_581051, JString, required = false,
                                 default = nil)
  if valid_581051 != nil:
    section.add "uploadType", valid_581051
  var valid_581052 = query.getOrDefault("quotaUser")
  valid_581052 = validateParameter(valid_581052, JString, required = false,
                                 default = nil)
  if valid_581052 != nil:
    section.add "quotaUser", valid_581052
  var valid_581053 = query.getOrDefault("callback")
  valid_581053 = validateParameter(valid_581053, JString, required = false,
                                 default = nil)
  if valid_581053 != nil:
    section.add "callback", valid_581053
  var valid_581054 = query.getOrDefault("fields")
  valid_581054 = validateParameter(valid_581054, JString, required = false,
                                 default = nil)
  if valid_581054 != nil:
    section.add "fields", valid_581054
  var valid_581055 = query.getOrDefault("access_token")
  valid_581055 = validateParameter(valid_581055, JString, required = false,
                                 default = nil)
  if valid_581055 != nil:
    section.add "access_token", valid_581055
  var valid_581056 = query.getOrDefault("upload_protocol")
  valid_581056 = validateParameter(valid_581056, JString, required = false,
                                 default = nil)
  if valid_581056 != nil:
    section.add "upload_protocol", valid_581056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581057: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581042;
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
  let valid = call_581057.validator(path, query, header, formData, body)
  let scheme = call_581057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581057.url(scheme.get, call_581057.host, call_581057.base,
                         call_581057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581057, url, valid)

proc call*(call_581058: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581042;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersWellKnownGetOpenidConfiguration
  ## Gets the OIDC discovery document for the cluster.
  ## See the
  ## [OpenID Connect Discovery 1.0
  ## specification](https://openid.net/specs/openid-connect-discovery-1_0.html)
  ## for details.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The cluster (project, location, cluster id) to get the discovery document
  ## for. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_581059 = newJObject()
  var query_581060 = newJObject()
  add(query_581060, "key", newJString(key))
  add(query_581060, "prettyPrint", newJBool(prettyPrint))
  add(query_581060, "oauth_token", newJString(oauthToken))
  add(query_581060, "$.xgafv", newJString(Xgafv))
  add(query_581060, "alt", newJString(alt))
  add(query_581060, "uploadType", newJString(uploadType))
  add(query_581060, "quotaUser", newJString(quotaUser))
  add(query_581060, "callback", newJString(callback))
  add(path_581059, "parent", newJString(parent))
  add(query_581060, "fields", newJString(fields))
  add(query_581060, "access_token", newJString(accessToken))
  add(query_581060, "upload_protocol", newJString(uploadProtocol))
  result = call_581058.call(path_581059, query_581060, nil, nil, nil)

var containerProjectsLocationsClustersWellKnownGetOpenidConfiguration* = Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581042(
    name: "containerProjectsLocationsClustersWellKnownGetOpenidConfiguration",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/.well-known/openid-configuration", validator: validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581043,
    base: "/",
    url: url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581044,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsAggregatedUsableSubnetworksList_581061 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsAggregatedUsableSubnetworksList_581063(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsAggregatedUsableSubnetworksList_581062(
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
  var valid_581064 = path.getOrDefault("parent")
  valid_581064 = validateParameter(valid_581064, JString, required = true,
                                 default = nil)
  if valid_581064 != nil:
    section.add "parent", valid_581064
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The max number of results per page that should be returned. If the number
  ## of available results is larger than `page_size`, a `next_page_token` is
  ## returned which can be used to get the next page of results in subsequent
  ## requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Filtering currently only supports equality on the networkProjectId and must
  ## be in the form: "networkProjectId=[PROJECTID]", where `networkProjectId`
  ## is the project which owns the listed subnetworks. This defaults to the
  ## parent project ID.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set this to the nextPageToken returned by
  ## previous list requests to get the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_581065 = query.getOrDefault("key")
  valid_581065 = validateParameter(valid_581065, JString, required = false,
                                 default = nil)
  if valid_581065 != nil:
    section.add "key", valid_581065
  var valid_581066 = query.getOrDefault("prettyPrint")
  valid_581066 = validateParameter(valid_581066, JBool, required = false,
                                 default = newJBool(true))
  if valid_581066 != nil:
    section.add "prettyPrint", valid_581066
  var valid_581067 = query.getOrDefault("oauth_token")
  valid_581067 = validateParameter(valid_581067, JString, required = false,
                                 default = nil)
  if valid_581067 != nil:
    section.add "oauth_token", valid_581067
  var valid_581068 = query.getOrDefault("$.xgafv")
  valid_581068 = validateParameter(valid_581068, JString, required = false,
                                 default = newJString("1"))
  if valid_581068 != nil:
    section.add "$.xgafv", valid_581068
  var valid_581069 = query.getOrDefault("pageSize")
  valid_581069 = validateParameter(valid_581069, JInt, required = false, default = nil)
  if valid_581069 != nil:
    section.add "pageSize", valid_581069
  var valid_581070 = query.getOrDefault("alt")
  valid_581070 = validateParameter(valid_581070, JString, required = false,
                                 default = newJString("json"))
  if valid_581070 != nil:
    section.add "alt", valid_581070
  var valid_581071 = query.getOrDefault("uploadType")
  valid_581071 = validateParameter(valid_581071, JString, required = false,
                                 default = nil)
  if valid_581071 != nil:
    section.add "uploadType", valid_581071
  var valid_581072 = query.getOrDefault("quotaUser")
  valid_581072 = validateParameter(valid_581072, JString, required = false,
                                 default = nil)
  if valid_581072 != nil:
    section.add "quotaUser", valid_581072
  var valid_581073 = query.getOrDefault("filter")
  valid_581073 = validateParameter(valid_581073, JString, required = false,
                                 default = nil)
  if valid_581073 != nil:
    section.add "filter", valid_581073
  var valid_581074 = query.getOrDefault("pageToken")
  valid_581074 = validateParameter(valid_581074, JString, required = false,
                                 default = nil)
  if valid_581074 != nil:
    section.add "pageToken", valid_581074
  var valid_581075 = query.getOrDefault("callback")
  valid_581075 = validateParameter(valid_581075, JString, required = false,
                                 default = nil)
  if valid_581075 != nil:
    section.add "callback", valid_581075
  var valid_581076 = query.getOrDefault("fields")
  valid_581076 = validateParameter(valid_581076, JString, required = false,
                                 default = nil)
  if valid_581076 != nil:
    section.add "fields", valid_581076
  var valid_581077 = query.getOrDefault("access_token")
  valid_581077 = validateParameter(valid_581077, JString, required = false,
                                 default = nil)
  if valid_581077 != nil:
    section.add "access_token", valid_581077
  var valid_581078 = query.getOrDefault("upload_protocol")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = nil)
  if valid_581078 != nil:
    section.add "upload_protocol", valid_581078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581079: Call_ContainerProjectsAggregatedUsableSubnetworksList_581061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists subnetworks that are usable for creating clusters in a project.
  ## 
  let valid = call_581079.validator(path, query, header, formData, body)
  let scheme = call_581079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581079.url(scheme.get, call_581079.host, call_581079.base,
                         call_581079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581079, url, valid)

proc call*(call_581080: Call_ContainerProjectsAggregatedUsableSubnetworksList_581061;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsAggregatedUsableSubnetworksList
  ## Lists subnetworks that are usable for creating clusters in a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The max number of results per page that should be returned. If the number
  ## of available results is larger than `page_size`, a `next_page_token` is
  ## returned which can be used to get the next page of results in subsequent
  ## requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Filtering currently only supports equality on the networkProjectId and must
  ## be in the form: "networkProjectId=[PROJECTID]", where `networkProjectId`
  ## is the project which owns the listed subnetworks. This defaults to the
  ## parent project ID.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set this to the nextPageToken returned by
  ## previous list requests to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent project where subnetworks are usable.
  ## Specified in the format 'projects/*'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_581081 = newJObject()
  var query_581082 = newJObject()
  add(query_581082, "key", newJString(key))
  add(query_581082, "prettyPrint", newJBool(prettyPrint))
  add(query_581082, "oauth_token", newJString(oauthToken))
  add(query_581082, "$.xgafv", newJString(Xgafv))
  add(query_581082, "pageSize", newJInt(pageSize))
  add(query_581082, "alt", newJString(alt))
  add(query_581082, "uploadType", newJString(uploadType))
  add(query_581082, "quotaUser", newJString(quotaUser))
  add(query_581082, "filter", newJString(filter))
  add(query_581082, "pageToken", newJString(pageToken))
  add(query_581082, "callback", newJString(callback))
  add(path_581081, "parent", newJString(parent))
  add(query_581082, "fields", newJString(fields))
  add(query_581082, "access_token", newJString(accessToken))
  add(query_581082, "upload_protocol", newJString(uploadProtocol))
  result = call_581080.call(path_581081, query_581082, nil, nil, nil)

var containerProjectsAggregatedUsableSubnetworksList* = Call_ContainerProjectsAggregatedUsableSubnetworksList_581061(
    name: "containerProjectsAggregatedUsableSubnetworksList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/aggregated/usableSubnetworks",
    validator: validate_ContainerProjectsAggregatedUsableSubnetworksList_581062,
    base: "/", url: url_ContainerProjectsAggregatedUsableSubnetworksList_581063,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCreate_581104 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersCreate_581106(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersCreate_581105(path: JsonNode;
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
  var valid_581107 = path.getOrDefault("parent")
  valid_581107 = validateParameter(valid_581107, JString, required = true,
                                 default = nil)
  if valid_581107 != nil:
    section.add "parent", valid_581107
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_581108 = query.getOrDefault("key")
  valid_581108 = validateParameter(valid_581108, JString, required = false,
                                 default = nil)
  if valid_581108 != nil:
    section.add "key", valid_581108
  var valid_581109 = query.getOrDefault("prettyPrint")
  valid_581109 = validateParameter(valid_581109, JBool, required = false,
                                 default = newJBool(true))
  if valid_581109 != nil:
    section.add "prettyPrint", valid_581109
  var valid_581110 = query.getOrDefault("oauth_token")
  valid_581110 = validateParameter(valid_581110, JString, required = false,
                                 default = nil)
  if valid_581110 != nil:
    section.add "oauth_token", valid_581110
  var valid_581111 = query.getOrDefault("$.xgafv")
  valid_581111 = validateParameter(valid_581111, JString, required = false,
                                 default = newJString("1"))
  if valid_581111 != nil:
    section.add "$.xgafv", valid_581111
  var valid_581112 = query.getOrDefault("alt")
  valid_581112 = validateParameter(valid_581112, JString, required = false,
                                 default = newJString("json"))
  if valid_581112 != nil:
    section.add "alt", valid_581112
  var valid_581113 = query.getOrDefault("uploadType")
  valid_581113 = validateParameter(valid_581113, JString, required = false,
                                 default = nil)
  if valid_581113 != nil:
    section.add "uploadType", valid_581113
  var valid_581114 = query.getOrDefault("quotaUser")
  valid_581114 = validateParameter(valid_581114, JString, required = false,
                                 default = nil)
  if valid_581114 != nil:
    section.add "quotaUser", valid_581114
  var valid_581115 = query.getOrDefault("callback")
  valid_581115 = validateParameter(valid_581115, JString, required = false,
                                 default = nil)
  if valid_581115 != nil:
    section.add "callback", valid_581115
  var valid_581116 = query.getOrDefault("fields")
  valid_581116 = validateParameter(valid_581116, JString, required = false,
                                 default = nil)
  if valid_581116 != nil:
    section.add "fields", valid_581116
  var valid_581117 = query.getOrDefault("access_token")
  valid_581117 = validateParameter(valid_581117, JString, required = false,
                                 default = nil)
  if valid_581117 != nil:
    section.add "access_token", valid_581117
  var valid_581118 = query.getOrDefault("upload_protocol")
  valid_581118 = validateParameter(valid_581118, JString, required = false,
                                 default = nil)
  if valid_581118 != nil:
    section.add "upload_protocol", valid_581118
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

proc call*(call_581120: Call_ContainerProjectsLocationsClustersCreate_581104;
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
  let valid = call_581120.validator(path, query, header, formData, body)
  let scheme = call_581120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581120.url(scheme.get, call_581120.host, call_581120.base,
                         call_581120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581120, url, valid)

proc call*(call_581121: Call_ContainerProjectsLocationsClustersCreate_581104;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent (project and location) where the cluster will be created.
  ## Specified in the format 'projects/*/locations/*'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_581122 = newJObject()
  var query_581123 = newJObject()
  var body_581124 = newJObject()
  add(query_581123, "key", newJString(key))
  add(query_581123, "prettyPrint", newJBool(prettyPrint))
  add(query_581123, "oauth_token", newJString(oauthToken))
  add(query_581123, "$.xgafv", newJString(Xgafv))
  add(query_581123, "alt", newJString(alt))
  add(query_581123, "uploadType", newJString(uploadType))
  add(query_581123, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581124 = body
  add(query_581123, "callback", newJString(callback))
  add(path_581122, "parent", newJString(parent))
  add(query_581123, "fields", newJString(fields))
  add(query_581123, "access_token", newJString(accessToken))
  add(query_581123, "upload_protocol", newJString(uploadProtocol))
  result = call_581121.call(path_581122, query_581123, nil, nil, body_581124)

var containerProjectsLocationsClustersCreate* = Call_ContainerProjectsLocationsClustersCreate_581104(
    name: "containerProjectsLocationsClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersCreate_581105,
    base: "/", url: url_ContainerProjectsLocationsClustersCreate_581106,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersList_581083 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersList_581085(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersList_581084(path: JsonNode;
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
  var valid_581086 = path.getOrDefault("parent")
  valid_581086 = validateParameter(valid_581086, JString, required = true,
                                 default = nil)
  if valid_581086 != nil:
    section.add "parent", valid_581086
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  var valid_581087 = query.getOrDefault("key")
  valid_581087 = validateParameter(valid_581087, JString, required = false,
                                 default = nil)
  if valid_581087 != nil:
    section.add "key", valid_581087
  var valid_581088 = query.getOrDefault("prettyPrint")
  valid_581088 = validateParameter(valid_581088, JBool, required = false,
                                 default = newJBool(true))
  if valid_581088 != nil:
    section.add "prettyPrint", valid_581088
  var valid_581089 = query.getOrDefault("oauth_token")
  valid_581089 = validateParameter(valid_581089, JString, required = false,
                                 default = nil)
  if valid_581089 != nil:
    section.add "oauth_token", valid_581089
  var valid_581090 = query.getOrDefault("$.xgafv")
  valid_581090 = validateParameter(valid_581090, JString, required = false,
                                 default = newJString("1"))
  if valid_581090 != nil:
    section.add "$.xgafv", valid_581090
  var valid_581091 = query.getOrDefault("alt")
  valid_581091 = validateParameter(valid_581091, JString, required = false,
                                 default = newJString("json"))
  if valid_581091 != nil:
    section.add "alt", valid_581091
  var valid_581092 = query.getOrDefault("uploadType")
  valid_581092 = validateParameter(valid_581092, JString, required = false,
                                 default = nil)
  if valid_581092 != nil:
    section.add "uploadType", valid_581092
  var valid_581093 = query.getOrDefault("quotaUser")
  valid_581093 = validateParameter(valid_581093, JString, required = false,
                                 default = nil)
  if valid_581093 != nil:
    section.add "quotaUser", valid_581093
  var valid_581094 = query.getOrDefault("zone")
  valid_581094 = validateParameter(valid_581094, JString, required = false,
                                 default = nil)
  if valid_581094 != nil:
    section.add "zone", valid_581094
  var valid_581095 = query.getOrDefault("callback")
  valid_581095 = validateParameter(valid_581095, JString, required = false,
                                 default = nil)
  if valid_581095 != nil:
    section.add "callback", valid_581095
  var valid_581096 = query.getOrDefault("fields")
  valid_581096 = validateParameter(valid_581096, JString, required = false,
                                 default = nil)
  if valid_581096 != nil:
    section.add "fields", valid_581096
  var valid_581097 = query.getOrDefault("access_token")
  valid_581097 = validateParameter(valid_581097, JString, required = false,
                                 default = nil)
  if valid_581097 != nil:
    section.add "access_token", valid_581097
  var valid_581098 = query.getOrDefault("upload_protocol")
  valid_581098 = validateParameter(valid_581098, JString, required = false,
                                 default = nil)
  if valid_581098 != nil:
    section.add "upload_protocol", valid_581098
  var valid_581099 = query.getOrDefault("projectId")
  valid_581099 = validateParameter(valid_581099, JString, required = false,
                                 default = nil)
  if valid_581099 != nil:
    section.add "projectId", valid_581099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581100: Call_ContainerProjectsLocationsClustersList_581083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_581100.validator(path, query, header, formData, body)
  let scheme = call_581100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581100.url(scheme.get, call_581100.host, call_581100.base,
                         call_581100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581100, url, valid)

proc call*(call_581101: Call_ContainerProjectsLocationsClustersList_581083;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; zone: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## containerProjectsLocationsClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field has been deprecated and replaced by the parent field.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent (project and location) where the clusters will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  var path_581102 = newJObject()
  var query_581103 = newJObject()
  add(query_581103, "key", newJString(key))
  add(query_581103, "prettyPrint", newJBool(prettyPrint))
  add(query_581103, "oauth_token", newJString(oauthToken))
  add(query_581103, "$.xgafv", newJString(Xgafv))
  add(query_581103, "alt", newJString(alt))
  add(query_581103, "uploadType", newJString(uploadType))
  add(query_581103, "quotaUser", newJString(quotaUser))
  add(query_581103, "zone", newJString(zone))
  add(query_581103, "callback", newJString(callback))
  add(path_581102, "parent", newJString(parent))
  add(query_581103, "fields", newJString(fields))
  add(query_581103, "access_token", newJString(accessToken))
  add(query_581103, "upload_protocol", newJString(uploadProtocol))
  add(query_581103, "projectId", newJString(projectId))
  result = call_581101.call(path_581102, query_581103, nil, nil, nil)

var containerProjectsLocationsClustersList* = Call_ContainerProjectsLocationsClustersList_581083(
    name: "containerProjectsLocationsClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersList_581084, base: "/",
    url: url_ContainerProjectsLocationsClustersList_581085,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersGetJwks_581125 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersGetJwks_581127(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersGetJwks_581126(path: JsonNode;
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
  var valid_581128 = path.getOrDefault("parent")
  valid_581128 = validateParameter(valid_581128, JString, required = true,
                                 default = nil)
  if valid_581128 != nil:
    section.add "parent", valid_581128
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_581129 = query.getOrDefault("key")
  valid_581129 = validateParameter(valid_581129, JString, required = false,
                                 default = nil)
  if valid_581129 != nil:
    section.add "key", valid_581129
  var valid_581130 = query.getOrDefault("prettyPrint")
  valid_581130 = validateParameter(valid_581130, JBool, required = false,
                                 default = newJBool(true))
  if valid_581130 != nil:
    section.add "prettyPrint", valid_581130
  var valid_581131 = query.getOrDefault("oauth_token")
  valid_581131 = validateParameter(valid_581131, JString, required = false,
                                 default = nil)
  if valid_581131 != nil:
    section.add "oauth_token", valid_581131
  var valid_581132 = query.getOrDefault("$.xgafv")
  valid_581132 = validateParameter(valid_581132, JString, required = false,
                                 default = newJString("1"))
  if valid_581132 != nil:
    section.add "$.xgafv", valid_581132
  var valid_581133 = query.getOrDefault("alt")
  valid_581133 = validateParameter(valid_581133, JString, required = false,
                                 default = newJString("json"))
  if valid_581133 != nil:
    section.add "alt", valid_581133
  var valid_581134 = query.getOrDefault("uploadType")
  valid_581134 = validateParameter(valid_581134, JString, required = false,
                                 default = nil)
  if valid_581134 != nil:
    section.add "uploadType", valid_581134
  var valid_581135 = query.getOrDefault("quotaUser")
  valid_581135 = validateParameter(valid_581135, JString, required = false,
                                 default = nil)
  if valid_581135 != nil:
    section.add "quotaUser", valid_581135
  var valid_581136 = query.getOrDefault("callback")
  valid_581136 = validateParameter(valid_581136, JString, required = false,
                                 default = nil)
  if valid_581136 != nil:
    section.add "callback", valid_581136
  var valid_581137 = query.getOrDefault("fields")
  valid_581137 = validateParameter(valid_581137, JString, required = false,
                                 default = nil)
  if valid_581137 != nil:
    section.add "fields", valid_581137
  var valid_581138 = query.getOrDefault("access_token")
  valid_581138 = validateParameter(valid_581138, JString, required = false,
                                 default = nil)
  if valid_581138 != nil:
    section.add "access_token", valid_581138
  var valid_581139 = query.getOrDefault("upload_protocol")
  valid_581139 = validateParameter(valid_581139, JString, required = false,
                                 default = nil)
  if valid_581139 != nil:
    section.add "upload_protocol", valid_581139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581140: Call_ContainerProjectsLocationsClustersGetJwks_581125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  let valid = call_581140.validator(path, query, header, formData, body)
  let scheme = call_581140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581140.url(scheme.get, call_581140.host, call_581140.base,
                         call_581140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581140, url, valid)

proc call*(call_581141: Call_ContainerProjectsLocationsClustersGetJwks_581125;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersGetJwks
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The cluster (project, location, cluster id) to get keys for. Specified in
  ## the format 'projects/*/locations/*/clusters/*'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_581142 = newJObject()
  var query_581143 = newJObject()
  add(query_581143, "key", newJString(key))
  add(query_581143, "prettyPrint", newJBool(prettyPrint))
  add(query_581143, "oauth_token", newJString(oauthToken))
  add(query_581143, "$.xgafv", newJString(Xgafv))
  add(query_581143, "alt", newJString(alt))
  add(query_581143, "uploadType", newJString(uploadType))
  add(query_581143, "quotaUser", newJString(quotaUser))
  add(query_581143, "callback", newJString(callback))
  add(path_581142, "parent", newJString(parent))
  add(query_581143, "fields", newJString(fields))
  add(query_581143, "access_token", newJString(accessToken))
  add(query_581143, "upload_protocol", newJString(uploadProtocol))
  result = call_581141.call(path_581142, query_581143, nil, nil, nil)

var containerProjectsLocationsClustersGetJwks* = Call_ContainerProjectsLocationsClustersGetJwks_581125(
    name: "containerProjectsLocationsClustersGetJwks", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/jwks",
    validator: validate_ContainerProjectsLocationsClustersGetJwks_581126,
    base: "/", url: url_ContainerProjectsLocationsClustersGetJwks_581127,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsCreate_581166 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersNodePoolsCreate_581168(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsCreate_581167(
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
  var valid_581169 = path.getOrDefault("parent")
  valid_581169 = validateParameter(valid_581169, JString, required = true,
                                 default = nil)
  if valid_581169 != nil:
    section.add "parent", valid_581169
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_581170 = query.getOrDefault("key")
  valid_581170 = validateParameter(valid_581170, JString, required = false,
                                 default = nil)
  if valid_581170 != nil:
    section.add "key", valid_581170
  var valid_581171 = query.getOrDefault("prettyPrint")
  valid_581171 = validateParameter(valid_581171, JBool, required = false,
                                 default = newJBool(true))
  if valid_581171 != nil:
    section.add "prettyPrint", valid_581171
  var valid_581172 = query.getOrDefault("oauth_token")
  valid_581172 = validateParameter(valid_581172, JString, required = false,
                                 default = nil)
  if valid_581172 != nil:
    section.add "oauth_token", valid_581172
  var valid_581173 = query.getOrDefault("$.xgafv")
  valid_581173 = validateParameter(valid_581173, JString, required = false,
                                 default = newJString("1"))
  if valid_581173 != nil:
    section.add "$.xgafv", valid_581173
  var valid_581174 = query.getOrDefault("alt")
  valid_581174 = validateParameter(valid_581174, JString, required = false,
                                 default = newJString("json"))
  if valid_581174 != nil:
    section.add "alt", valid_581174
  var valid_581175 = query.getOrDefault("uploadType")
  valid_581175 = validateParameter(valid_581175, JString, required = false,
                                 default = nil)
  if valid_581175 != nil:
    section.add "uploadType", valid_581175
  var valid_581176 = query.getOrDefault("quotaUser")
  valid_581176 = validateParameter(valid_581176, JString, required = false,
                                 default = nil)
  if valid_581176 != nil:
    section.add "quotaUser", valid_581176
  var valid_581177 = query.getOrDefault("callback")
  valid_581177 = validateParameter(valid_581177, JString, required = false,
                                 default = nil)
  if valid_581177 != nil:
    section.add "callback", valid_581177
  var valid_581178 = query.getOrDefault("fields")
  valid_581178 = validateParameter(valid_581178, JString, required = false,
                                 default = nil)
  if valid_581178 != nil:
    section.add "fields", valid_581178
  var valid_581179 = query.getOrDefault("access_token")
  valid_581179 = validateParameter(valid_581179, JString, required = false,
                                 default = nil)
  if valid_581179 != nil:
    section.add "access_token", valid_581179
  var valid_581180 = query.getOrDefault("upload_protocol")
  valid_581180 = validateParameter(valid_581180, JString, required = false,
                                 default = nil)
  if valid_581180 != nil:
    section.add "upload_protocol", valid_581180
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

proc call*(call_581182: Call_ContainerProjectsLocationsClustersNodePoolsCreate_581166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_581182.validator(path, query, header, formData, body)
  let scheme = call_581182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581182.url(scheme.get, call_581182.host, call_581182.base,
                         call_581182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581182, url, valid)

proc call*(call_581183: Call_ContainerProjectsLocationsClustersNodePoolsCreate_581166;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pool will be
  ## created. Specified in the format
  ## 'projects/*/locations/*/clusters/*'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_581184 = newJObject()
  var query_581185 = newJObject()
  var body_581186 = newJObject()
  add(query_581185, "key", newJString(key))
  add(query_581185, "prettyPrint", newJBool(prettyPrint))
  add(query_581185, "oauth_token", newJString(oauthToken))
  add(query_581185, "$.xgafv", newJString(Xgafv))
  add(query_581185, "alt", newJString(alt))
  add(query_581185, "uploadType", newJString(uploadType))
  add(query_581185, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581186 = body
  add(query_581185, "callback", newJString(callback))
  add(path_581184, "parent", newJString(parent))
  add(query_581185, "fields", newJString(fields))
  add(query_581185, "access_token", newJString(accessToken))
  add(query_581185, "upload_protocol", newJString(uploadProtocol))
  result = call_581183.call(path_581184, query_581185, nil, nil, body_581186)

var containerProjectsLocationsClustersNodePoolsCreate* = Call_ContainerProjectsLocationsClustersNodePoolsCreate_581166(
    name: "containerProjectsLocationsClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsCreate_581167,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsCreate_581168,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsList_581144 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsClustersNodePoolsList_581146(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsClustersNodePoolsList_581145(
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
  var valid_581147 = path.getOrDefault("parent")
  valid_581147 = validateParameter(valid_581147, JString, required = true,
                                 default = nil)
  if valid_581147 != nil:
    section.add "parent", valid_581147
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: JString
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  var valid_581148 = query.getOrDefault("key")
  valid_581148 = validateParameter(valid_581148, JString, required = false,
                                 default = nil)
  if valid_581148 != nil:
    section.add "key", valid_581148
  var valid_581149 = query.getOrDefault("prettyPrint")
  valid_581149 = validateParameter(valid_581149, JBool, required = false,
                                 default = newJBool(true))
  if valid_581149 != nil:
    section.add "prettyPrint", valid_581149
  var valid_581150 = query.getOrDefault("oauth_token")
  valid_581150 = validateParameter(valid_581150, JString, required = false,
                                 default = nil)
  if valid_581150 != nil:
    section.add "oauth_token", valid_581150
  var valid_581151 = query.getOrDefault("$.xgafv")
  valid_581151 = validateParameter(valid_581151, JString, required = false,
                                 default = newJString("1"))
  if valid_581151 != nil:
    section.add "$.xgafv", valid_581151
  var valid_581152 = query.getOrDefault("alt")
  valid_581152 = validateParameter(valid_581152, JString, required = false,
                                 default = newJString("json"))
  if valid_581152 != nil:
    section.add "alt", valid_581152
  var valid_581153 = query.getOrDefault("uploadType")
  valid_581153 = validateParameter(valid_581153, JString, required = false,
                                 default = nil)
  if valid_581153 != nil:
    section.add "uploadType", valid_581153
  var valid_581154 = query.getOrDefault("quotaUser")
  valid_581154 = validateParameter(valid_581154, JString, required = false,
                                 default = nil)
  if valid_581154 != nil:
    section.add "quotaUser", valid_581154
  var valid_581155 = query.getOrDefault("clusterId")
  valid_581155 = validateParameter(valid_581155, JString, required = false,
                                 default = nil)
  if valid_581155 != nil:
    section.add "clusterId", valid_581155
  var valid_581156 = query.getOrDefault("zone")
  valid_581156 = validateParameter(valid_581156, JString, required = false,
                                 default = nil)
  if valid_581156 != nil:
    section.add "zone", valid_581156
  var valid_581157 = query.getOrDefault("callback")
  valid_581157 = validateParameter(valid_581157, JString, required = false,
                                 default = nil)
  if valid_581157 != nil:
    section.add "callback", valid_581157
  var valid_581158 = query.getOrDefault("fields")
  valid_581158 = validateParameter(valid_581158, JString, required = false,
                                 default = nil)
  if valid_581158 != nil:
    section.add "fields", valid_581158
  var valid_581159 = query.getOrDefault("access_token")
  valid_581159 = validateParameter(valid_581159, JString, required = false,
                                 default = nil)
  if valid_581159 != nil:
    section.add "access_token", valid_581159
  var valid_581160 = query.getOrDefault("upload_protocol")
  valid_581160 = validateParameter(valid_581160, JString, required = false,
                                 default = nil)
  if valid_581160 != nil:
    section.add "upload_protocol", valid_581160
  var valid_581161 = query.getOrDefault("projectId")
  valid_581161 = validateParameter(valid_581161, JString, required = false,
                                 default = nil)
  if valid_581161 != nil:
    section.add "projectId", valid_581161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581162: Call_ContainerProjectsLocationsClustersNodePoolsList_581144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_581162.validator(path, query, header, formData, body)
  let scheme = call_581162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581162.url(scheme.get, call_581162.host, call_581162.base,
                         call_581162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581162, url, valid)

proc call*(call_581163: Call_ContainerProjectsLocationsClustersNodePoolsList_581144;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; clusterId: string = "";
          zone: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string
  ##            : Deprecated. The name of the cluster.
  ## This field has been deprecated and replaced by the parent field.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field has been deprecated and replaced by the parent field.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pools will be
  ## listed. Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field has been deprecated and replaced by the parent field.
  var path_581164 = newJObject()
  var query_581165 = newJObject()
  add(query_581165, "key", newJString(key))
  add(query_581165, "prettyPrint", newJBool(prettyPrint))
  add(query_581165, "oauth_token", newJString(oauthToken))
  add(query_581165, "$.xgafv", newJString(Xgafv))
  add(query_581165, "alt", newJString(alt))
  add(query_581165, "uploadType", newJString(uploadType))
  add(query_581165, "quotaUser", newJString(quotaUser))
  add(query_581165, "clusterId", newJString(clusterId))
  add(query_581165, "zone", newJString(zone))
  add(query_581165, "callback", newJString(callback))
  add(path_581164, "parent", newJString(parent))
  add(query_581165, "fields", newJString(fields))
  add(query_581165, "access_token", newJString(accessToken))
  add(query_581165, "upload_protocol", newJString(uploadProtocol))
  add(query_581165, "projectId", newJString(projectId))
  result = call_581163.call(path_581164, query_581165, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsList* = Call_ContainerProjectsLocationsClustersNodePoolsList_581144(
    name: "containerProjectsLocationsClustersNodePoolsList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsList_581145,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsList_581146,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsList_581187 = ref object of OpenApiRestCall_579373
proc url_ContainerProjectsLocationsOperationsList_581189(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ContainerProjectsLocationsOperationsList_581188(path: JsonNode;
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
  var valid_581190 = path.getOrDefault("parent")
  valid_581190 = validateParameter(valid_581190, JString, required = true,
                                 default = nil)
  if valid_581190 != nil:
    section.add "parent", valid_581190
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: JString
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  section = newJObject()
  var valid_581191 = query.getOrDefault("key")
  valid_581191 = validateParameter(valid_581191, JString, required = false,
                                 default = nil)
  if valid_581191 != nil:
    section.add "key", valid_581191
  var valid_581192 = query.getOrDefault("prettyPrint")
  valid_581192 = validateParameter(valid_581192, JBool, required = false,
                                 default = newJBool(true))
  if valid_581192 != nil:
    section.add "prettyPrint", valid_581192
  var valid_581193 = query.getOrDefault("oauth_token")
  valid_581193 = validateParameter(valid_581193, JString, required = false,
                                 default = nil)
  if valid_581193 != nil:
    section.add "oauth_token", valid_581193
  var valid_581194 = query.getOrDefault("$.xgafv")
  valid_581194 = validateParameter(valid_581194, JString, required = false,
                                 default = newJString("1"))
  if valid_581194 != nil:
    section.add "$.xgafv", valid_581194
  var valid_581195 = query.getOrDefault("alt")
  valid_581195 = validateParameter(valid_581195, JString, required = false,
                                 default = newJString("json"))
  if valid_581195 != nil:
    section.add "alt", valid_581195
  var valid_581196 = query.getOrDefault("uploadType")
  valid_581196 = validateParameter(valid_581196, JString, required = false,
                                 default = nil)
  if valid_581196 != nil:
    section.add "uploadType", valid_581196
  var valid_581197 = query.getOrDefault("quotaUser")
  valid_581197 = validateParameter(valid_581197, JString, required = false,
                                 default = nil)
  if valid_581197 != nil:
    section.add "quotaUser", valid_581197
  var valid_581198 = query.getOrDefault("zone")
  valid_581198 = validateParameter(valid_581198, JString, required = false,
                                 default = nil)
  if valid_581198 != nil:
    section.add "zone", valid_581198
  var valid_581199 = query.getOrDefault("callback")
  valid_581199 = validateParameter(valid_581199, JString, required = false,
                                 default = nil)
  if valid_581199 != nil:
    section.add "callback", valid_581199
  var valid_581200 = query.getOrDefault("fields")
  valid_581200 = validateParameter(valid_581200, JString, required = false,
                                 default = nil)
  if valid_581200 != nil:
    section.add "fields", valid_581200
  var valid_581201 = query.getOrDefault("access_token")
  valid_581201 = validateParameter(valid_581201, JString, required = false,
                                 default = nil)
  if valid_581201 != nil:
    section.add "access_token", valid_581201
  var valid_581202 = query.getOrDefault("upload_protocol")
  valid_581202 = validateParameter(valid_581202, JString, required = false,
                                 default = nil)
  if valid_581202 != nil:
    section.add "upload_protocol", valid_581202
  var valid_581203 = query.getOrDefault("projectId")
  valid_581203 = validateParameter(valid_581203, JString, required = false,
                                 default = nil)
  if valid_581203 != nil:
    section.add "projectId", valid_581203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581204: Call_ContainerProjectsLocationsOperationsList_581187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_581204.validator(path, query, header, formData, body)
  let scheme = call_581204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581204.url(scheme.get, call_581204.host, call_581204.base,
                         call_581204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581204, url, valid)

proc call*(call_581205: Call_ContainerProjectsLocationsOperationsList_581187;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; zone: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## containerProjectsLocationsOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string
  ##       : Deprecated. The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) to return operations for, or `-` for
  ## all zones. This field has been deprecated and replaced by the parent field.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent (project and location) where the operations will be listed.
  ## Specified in the format 'projects/*/locations/*'.
  ## Location "-" matches all zones and all regions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : Deprecated. The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field has been deprecated and replaced by the parent field.
  var path_581206 = newJObject()
  var query_581207 = newJObject()
  add(query_581207, "key", newJString(key))
  add(query_581207, "prettyPrint", newJBool(prettyPrint))
  add(query_581207, "oauth_token", newJString(oauthToken))
  add(query_581207, "$.xgafv", newJString(Xgafv))
  add(query_581207, "alt", newJString(alt))
  add(query_581207, "uploadType", newJString(uploadType))
  add(query_581207, "quotaUser", newJString(quotaUser))
  add(query_581207, "zone", newJString(zone))
  add(query_581207, "callback", newJString(callback))
  add(path_581206, "parent", newJString(parent))
  add(query_581207, "fields", newJString(fields))
  add(query_581207, "access_token", newJString(accessToken))
  add(query_581207, "upload_protocol", newJString(uploadProtocol))
  add(query_581207, "projectId", newJString(projectId))
  result = call_581205.call(path_581206, query_581207, nil, nil, nil)

var containerProjectsLocationsOperationsList* = Call_ContainerProjectsLocationsOperationsList_581187(
    name: "containerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/operations",
    validator: validate_ContainerProjectsLocationsOperationsList_581188,
    base: "/", url: url_ContainerProjectsLocationsOperationsList_581189,
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
