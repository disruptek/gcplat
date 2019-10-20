
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  Call_ContainerProjectsZonesClustersCreate_578909 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersCreate_578911(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersCreate_578910(path: JsonNode;
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
  var valid_578912 = path.getOrDefault("projectId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "projectId", valid_578912
  var valid_578913 = path.getOrDefault("zone")
  valid_578913 = validateParameter(valid_578913, JString, required = true,
                                 default = nil)
  if valid_578913 != nil:
    section.add "zone", valid_578913
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
  var valid_578914 = query.getOrDefault("key")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "key", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("$.xgafv")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("1"))
  if valid_578917 != nil:
    section.add "$.xgafv", valid_578917
  var valid_578918 = query.getOrDefault("alt")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = newJString("json"))
  if valid_578918 != nil:
    section.add "alt", valid_578918
  var valid_578919 = query.getOrDefault("uploadType")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "uploadType", valid_578919
  var valid_578920 = query.getOrDefault("quotaUser")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "quotaUser", valid_578920
  var valid_578921 = query.getOrDefault("callback")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "callback", valid_578921
  var valid_578922 = query.getOrDefault("fields")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "fields", valid_578922
  var valid_578923 = query.getOrDefault("access_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "access_token", valid_578923
  var valid_578924 = query.getOrDefault("upload_protocol")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "upload_protocol", valid_578924
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

proc call*(call_578926: Call_ContainerProjectsZonesClustersCreate_578909;
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
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_ContainerProjectsZonesClustersCreate_578909;
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
  var path_578928 = newJObject()
  var query_578929 = newJObject()
  var body_578930 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(path_578928, "projectId", newJString(projectId))
  add(query_578929, "$.xgafv", newJString(Xgafv))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "uploadType", newJString(uploadType))
  add(query_578929, "quotaUser", newJString(quotaUser))
  add(path_578928, "zone", newJString(zone))
  if body != nil:
    body_578930 = body
  add(query_578929, "callback", newJString(callback))
  add(query_578929, "fields", newJString(fields))
  add(query_578929, "access_token", newJString(accessToken))
  add(query_578929, "upload_protocol", newJString(uploadProtocol))
  result = call_578927.call(path_578928, query_578929, nil, nil, body_578930)

var containerProjectsZonesClustersCreate* = Call_ContainerProjectsZonesClustersCreate_578909(
    name: "containerProjectsZonesClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersCreate_578910, base: "/",
    url: url_ContainerProjectsZonesClustersCreate_578911, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersList_578619 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersList_578621(protocol: Scheme; host: string;
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

proc validate_ContainerProjectsZonesClustersList_578620(path: JsonNode;
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
  var valid_578747 = path.getOrDefault("projectId")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "projectId", valid_578747
  var valid_578748 = path.getOrDefault("zone")
  valid_578748 = validateParameter(valid_578748, JString, required = true,
                                 default = nil)
  if valid_578748 != nil:
    section.add "zone", valid_578748
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
  var valid_578749 = query.getOrDefault("key")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "key", valid_578749
  var valid_578763 = query.getOrDefault("prettyPrint")
  valid_578763 = validateParameter(valid_578763, JBool, required = false,
                                 default = newJBool(true))
  if valid_578763 != nil:
    section.add "prettyPrint", valid_578763
  var valid_578764 = query.getOrDefault("oauth_token")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "oauth_token", valid_578764
  var valid_578765 = query.getOrDefault("$.xgafv")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("1"))
  if valid_578765 != nil:
    section.add "$.xgafv", valid_578765
  var valid_578766 = query.getOrDefault("alt")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = newJString("json"))
  if valid_578766 != nil:
    section.add "alt", valid_578766
  var valid_578767 = query.getOrDefault("uploadType")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "uploadType", valid_578767
  var valid_578768 = query.getOrDefault("parent")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "parent", valid_578768
  var valid_578769 = query.getOrDefault("quotaUser")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "quotaUser", valid_578769
  var valid_578770 = query.getOrDefault("callback")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "callback", valid_578770
  var valid_578771 = query.getOrDefault("fields")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "fields", valid_578771
  var valid_578772 = query.getOrDefault("access_token")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "access_token", valid_578772
  var valid_578773 = query.getOrDefault("upload_protocol")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "upload_protocol", valid_578773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578796: Call_ContainerProjectsZonesClustersList_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_578796.validator(path, query, header, formData, body)
  let scheme = call_578796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578796.url(scheme.get, call_578796.host, call_578796.base,
                         call_578796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578796, url, valid)

proc call*(call_578867: Call_ContainerProjectsZonesClustersList_578619;
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
  var path_578868 = newJObject()
  var query_578870 = newJObject()
  add(query_578870, "key", newJString(key))
  add(query_578870, "prettyPrint", newJBool(prettyPrint))
  add(query_578870, "oauth_token", newJString(oauthToken))
  add(path_578868, "projectId", newJString(projectId))
  add(query_578870, "$.xgafv", newJString(Xgafv))
  add(query_578870, "alt", newJString(alt))
  add(query_578870, "uploadType", newJString(uploadType))
  add(query_578870, "parent", newJString(parent))
  add(query_578870, "quotaUser", newJString(quotaUser))
  add(path_578868, "zone", newJString(zone))
  add(query_578870, "callback", newJString(callback))
  add(query_578870, "fields", newJString(fields))
  add(query_578870, "access_token", newJString(accessToken))
  add(query_578870, "upload_protocol", newJString(uploadProtocol))
  result = call_578867.call(path_578868, query_578870, nil, nil, nil)

var containerProjectsZonesClustersList* = Call_ContainerProjectsZonesClustersList_578619(
    name: "containerProjectsZonesClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersList_578620, base: "/",
    url: url_ContainerProjectsZonesClustersList_578621, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersUpdate_578953 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersUpdate_578955(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersUpdate_578954(path: JsonNode;
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
  var valid_578956 = path.getOrDefault("projectId")
  valid_578956 = validateParameter(valid_578956, JString, required = true,
                                 default = nil)
  if valid_578956 != nil:
    section.add "projectId", valid_578956
  var valid_578957 = path.getOrDefault("clusterId")
  valid_578957 = validateParameter(valid_578957, JString, required = true,
                                 default = nil)
  if valid_578957 != nil:
    section.add "clusterId", valid_578957
  var valid_578958 = path.getOrDefault("zone")
  valid_578958 = validateParameter(valid_578958, JString, required = true,
                                 default = nil)
  if valid_578958 != nil:
    section.add "zone", valid_578958
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
  var valid_578959 = query.getOrDefault("key")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "key", valid_578959
  var valid_578960 = query.getOrDefault("prettyPrint")
  valid_578960 = validateParameter(valid_578960, JBool, required = false,
                                 default = newJBool(true))
  if valid_578960 != nil:
    section.add "prettyPrint", valid_578960
  var valid_578961 = query.getOrDefault("oauth_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "oauth_token", valid_578961
  var valid_578962 = query.getOrDefault("$.xgafv")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = newJString("1"))
  if valid_578962 != nil:
    section.add "$.xgafv", valid_578962
  var valid_578963 = query.getOrDefault("alt")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("json"))
  if valid_578963 != nil:
    section.add "alt", valid_578963
  var valid_578964 = query.getOrDefault("uploadType")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "uploadType", valid_578964
  var valid_578965 = query.getOrDefault("quotaUser")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "quotaUser", valid_578965
  var valid_578966 = query.getOrDefault("callback")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "callback", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
  var valid_578968 = query.getOrDefault("access_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "access_token", valid_578968
  var valid_578969 = query.getOrDefault("upload_protocol")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "upload_protocol", valid_578969
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

proc call*(call_578971: Call_ContainerProjectsZonesClustersUpdate_578953;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific cluster.
  ## 
  let valid = call_578971.validator(path, query, header, formData, body)
  let scheme = call_578971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578971.url(scheme.get, call_578971.host, call_578971.base,
                         call_578971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578971, url, valid)

proc call*(call_578972: Call_ContainerProjectsZonesClustersUpdate_578953;
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
  var path_578973 = newJObject()
  var query_578974 = newJObject()
  var body_578975 = newJObject()
  add(query_578974, "key", newJString(key))
  add(query_578974, "prettyPrint", newJBool(prettyPrint))
  add(query_578974, "oauth_token", newJString(oauthToken))
  add(path_578973, "projectId", newJString(projectId))
  add(query_578974, "$.xgafv", newJString(Xgafv))
  add(query_578974, "alt", newJString(alt))
  add(query_578974, "uploadType", newJString(uploadType))
  add(query_578974, "quotaUser", newJString(quotaUser))
  add(path_578973, "clusterId", newJString(clusterId))
  add(path_578973, "zone", newJString(zone))
  if body != nil:
    body_578975 = body
  add(query_578974, "callback", newJString(callback))
  add(query_578974, "fields", newJString(fields))
  add(query_578974, "access_token", newJString(accessToken))
  add(query_578974, "upload_protocol", newJString(uploadProtocol))
  result = call_578972.call(path_578973, query_578974, nil, nil, body_578975)

var containerProjectsZonesClustersUpdate* = Call_ContainerProjectsZonesClustersUpdate_578953(
    name: "containerProjectsZonesClustersUpdate", meth: HttpMethod.HttpPut,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersUpdate_578954, base: "/",
    url: url_ContainerProjectsZonesClustersUpdate_578955, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersGet_578931 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersGet_578933(protocol: Scheme; host: string;
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

proc validate_ContainerProjectsZonesClustersGet_578932(path: JsonNode;
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
  var valid_578934 = path.getOrDefault("projectId")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "projectId", valid_578934
  var valid_578935 = path.getOrDefault("clusterId")
  valid_578935 = validateParameter(valid_578935, JString, required = true,
                                 default = nil)
  if valid_578935 != nil:
    section.add "clusterId", valid_578935
  var valid_578936 = path.getOrDefault("zone")
  valid_578936 = validateParameter(valid_578936, JString, required = true,
                                 default = nil)
  if valid_578936 != nil:
    section.add "zone", valid_578936
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
  var valid_578937 = query.getOrDefault("key")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "key", valid_578937
  var valid_578938 = query.getOrDefault("prettyPrint")
  valid_578938 = validateParameter(valid_578938, JBool, required = false,
                                 default = newJBool(true))
  if valid_578938 != nil:
    section.add "prettyPrint", valid_578938
  var valid_578939 = query.getOrDefault("oauth_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "oauth_token", valid_578939
  var valid_578940 = query.getOrDefault("name")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "name", valid_578940
  var valid_578941 = query.getOrDefault("$.xgafv")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("1"))
  if valid_578941 != nil:
    section.add "$.xgafv", valid_578941
  var valid_578942 = query.getOrDefault("alt")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = newJString("json"))
  if valid_578942 != nil:
    section.add "alt", valid_578942
  var valid_578943 = query.getOrDefault("uploadType")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "uploadType", valid_578943
  var valid_578944 = query.getOrDefault("quotaUser")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "quotaUser", valid_578944
  var valid_578945 = query.getOrDefault("callback")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "callback", valid_578945
  var valid_578946 = query.getOrDefault("fields")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "fields", valid_578946
  var valid_578947 = query.getOrDefault("access_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "access_token", valid_578947
  var valid_578948 = query.getOrDefault("upload_protocol")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "upload_protocol", valid_578948
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578949: Call_ContainerProjectsZonesClustersGet_578931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific cluster.
  ## 
  let valid = call_578949.validator(path, query, header, formData, body)
  let scheme = call_578949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578949.url(scheme.get, call_578949.host, call_578949.base,
                         call_578949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578949, url, valid)

proc call*(call_578950: Call_ContainerProjectsZonesClustersGet_578931;
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
  var path_578951 = newJObject()
  var query_578952 = newJObject()
  add(query_578952, "key", newJString(key))
  add(query_578952, "prettyPrint", newJBool(prettyPrint))
  add(query_578952, "oauth_token", newJString(oauthToken))
  add(query_578952, "name", newJString(name))
  add(path_578951, "projectId", newJString(projectId))
  add(query_578952, "$.xgafv", newJString(Xgafv))
  add(query_578952, "alt", newJString(alt))
  add(query_578952, "uploadType", newJString(uploadType))
  add(query_578952, "quotaUser", newJString(quotaUser))
  add(path_578951, "clusterId", newJString(clusterId))
  add(path_578951, "zone", newJString(zone))
  add(query_578952, "callback", newJString(callback))
  add(query_578952, "fields", newJString(fields))
  add(query_578952, "access_token", newJString(accessToken))
  add(query_578952, "upload_protocol", newJString(uploadProtocol))
  result = call_578950.call(path_578951, query_578952, nil, nil, nil)

var containerProjectsZonesClustersGet* = Call_ContainerProjectsZonesClustersGet_578931(
    name: "containerProjectsZonesClustersGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersGet_578932, base: "/",
    url: url_ContainerProjectsZonesClustersGet_578933, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersDelete_578976 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersDelete_578978(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersDelete_578977(path: JsonNode;
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
  var valid_578979 = path.getOrDefault("projectId")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "projectId", valid_578979
  var valid_578980 = path.getOrDefault("clusterId")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "clusterId", valid_578980
  var valid_578981 = path.getOrDefault("zone")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "zone", valid_578981
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
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("name")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "name", valid_578985
  var valid_578986 = query.getOrDefault("$.xgafv")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("1"))
  if valid_578986 != nil:
    section.add "$.xgafv", valid_578986
  var valid_578987 = query.getOrDefault("alt")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("json"))
  if valid_578987 != nil:
    section.add "alt", valid_578987
  var valid_578988 = query.getOrDefault("uploadType")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "uploadType", valid_578988
  var valid_578989 = query.getOrDefault("quotaUser")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "quotaUser", valid_578989
  var valid_578990 = query.getOrDefault("callback")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "callback", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  var valid_578992 = query.getOrDefault("access_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "access_token", valid_578992
  var valid_578993 = query.getOrDefault("upload_protocol")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "upload_protocol", valid_578993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578994: Call_ContainerProjectsZonesClustersDelete_578976;
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
  let valid = call_578994.validator(path, query, header, formData, body)
  let scheme = call_578994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578994.url(scheme.get, call_578994.host, call_578994.base,
                         call_578994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578994, url, valid)

proc call*(call_578995: Call_ContainerProjectsZonesClustersDelete_578976;
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
  var path_578996 = newJObject()
  var query_578997 = newJObject()
  add(query_578997, "key", newJString(key))
  add(query_578997, "prettyPrint", newJBool(prettyPrint))
  add(query_578997, "oauth_token", newJString(oauthToken))
  add(query_578997, "name", newJString(name))
  add(path_578996, "projectId", newJString(projectId))
  add(query_578997, "$.xgafv", newJString(Xgafv))
  add(query_578997, "alt", newJString(alt))
  add(query_578997, "uploadType", newJString(uploadType))
  add(query_578997, "quotaUser", newJString(quotaUser))
  add(path_578996, "clusterId", newJString(clusterId))
  add(path_578996, "zone", newJString(zone))
  add(query_578997, "callback", newJString(callback))
  add(query_578997, "fields", newJString(fields))
  add(query_578997, "access_token", newJString(accessToken))
  add(query_578997, "upload_protocol", newJString(uploadProtocol))
  result = call_578995.call(path_578996, query_578997, nil, nil, nil)

var containerProjectsZonesClustersDelete* = Call_ContainerProjectsZonesClustersDelete_578976(
    name: "containerProjectsZonesClustersDelete", meth: HttpMethod.HttpDelete,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersDelete_578977, base: "/",
    url: url_ContainerProjectsZonesClustersDelete_578978, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersAddons_578998 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersAddons_579000(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersAddons_578999(path: JsonNode;
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
  var valid_579001 = path.getOrDefault("projectId")
  valid_579001 = validateParameter(valid_579001, JString, required = true,
                                 default = nil)
  if valid_579001 != nil:
    section.add "projectId", valid_579001
  var valid_579002 = path.getOrDefault("clusterId")
  valid_579002 = validateParameter(valid_579002, JString, required = true,
                                 default = nil)
  if valid_579002 != nil:
    section.add "clusterId", valid_579002
  var valid_579003 = path.getOrDefault("zone")
  valid_579003 = validateParameter(valid_579003, JString, required = true,
                                 default = nil)
  if valid_579003 != nil:
    section.add "zone", valid_579003
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
  var valid_579004 = query.getOrDefault("key")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "key", valid_579004
  var valid_579005 = query.getOrDefault("prettyPrint")
  valid_579005 = validateParameter(valid_579005, JBool, required = false,
                                 default = newJBool(true))
  if valid_579005 != nil:
    section.add "prettyPrint", valid_579005
  var valid_579006 = query.getOrDefault("oauth_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "oauth_token", valid_579006
  var valid_579007 = query.getOrDefault("$.xgafv")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("1"))
  if valid_579007 != nil:
    section.add "$.xgafv", valid_579007
  var valid_579008 = query.getOrDefault("alt")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("json"))
  if valid_579008 != nil:
    section.add "alt", valid_579008
  var valid_579009 = query.getOrDefault("uploadType")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "uploadType", valid_579009
  var valid_579010 = query.getOrDefault("quotaUser")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "quotaUser", valid_579010
  var valid_579011 = query.getOrDefault("callback")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "callback", valid_579011
  var valid_579012 = query.getOrDefault("fields")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "fields", valid_579012
  var valid_579013 = query.getOrDefault("access_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "access_token", valid_579013
  var valid_579014 = query.getOrDefault("upload_protocol")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "upload_protocol", valid_579014
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

proc call*(call_579016: Call_ContainerProjectsZonesClustersAddons_578998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_579016.validator(path, query, header, formData, body)
  let scheme = call_579016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579016.url(scheme.get, call_579016.host, call_579016.base,
                         call_579016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579016, url, valid)

proc call*(call_579017: Call_ContainerProjectsZonesClustersAddons_578998;
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
  var path_579018 = newJObject()
  var query_579019 = newJObject()
  var body_579020 = newJObject()
  add(query_579019, "key", newJString(key))
  add(query_579019, "prettyPrint", newJBool(prettyPrint))
  add(query_579019, "oauth_token", newJString(oauthToken))
  add(path_579018, "projectId", newJString(projectId))
  add(query_579019, "$.xgafv", newJString(Xgafv))
  add(query_579019, "alt", newJString(alt))
  add(query_579019, "uploadType", newJString(uploadType))
  add(query_579019, "quotaUser", newJString(quotaUser))
  add(path_579018, "clusterId", newJString(clusterId))
  add(path_579018, "zone", newJString(zone))
  if body != nil:
    body_579020 = body
  add(query_579019, "callback", newJString(callback))
  add(query_579019, "fields", newJString(fields))
  add(query_579019, "access_token", newJString(accessToken))
  add(query_579019, "upload_protocol", newJString(uploadProtocol))
  result = call_579017.call(path_579018, query_579019, nil, nil, body_579020)

var containerProjectsZonesClustersAddons* = Call_ContainerProjectsZonesClustersAddons_578998(
    name: "containerProjectsZonesClustersAddons", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/addons",
    validator: validate_ContainerProjectsZonesClustersAddons_578999, base: "/",
    url: url_ContainerProjectsZonesClustersAddons_579000, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLegacyAbac_579021 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersLegacyAbac_579023(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersLegacyAbac_579022(path: JsonNode;
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
  var valid_579024 = path.getOrDefault("projectId")
  valid_579024 = validateParameter(valid_579024, JString, required = true,
                                 default = nil)
  if valid_579024 != nil:
    section.add "projectId", valid_579024
  var valid_579025 = path.getOrDefault("clusterId")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "clusterId", valid_579025
  var valid_579026 = path.getOrDefault("zone")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "zone", valid_579026
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
  var valid_579027 = query.getOrDefault("key")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "key", valid_579027
  var valid_579028 = query.getOrDefault("prettyPrint")
  valid_579028 = validateParameter(valid_579028, JBool, required = false,
                                 default = newJBool(true))
  if valid_579028 != nil:
    section.add "prettyPrint", valid_579028
  var valid_579029 = query.getOrDefault("oauth_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "oauth_token", valid_579029
  var valid_579030 = query.getOrDefault("$.xgafv")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("1"))
  if valid_579030 != nil:
    section.add "$.xgafv", valid_579030
  var valid_579031 = query.getOrDefault("alt")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("json"))
  if valid_579031 != nil:
    section.add "alt", valid_579031
  var valid_579032 = query.getOrDefault("uploadType")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "uploadType", valid_579032
  var valid_579033 = query.getOrDefault("quotaUser")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "quotaUser", valid_579033
  var valid_579034 = query.getOrDefault("callback")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "callback", valid_579034
  var valid_579035 = query.getOrDefault("fields")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "fields", valid_579035
  var valid_579036 = query.getOrDefault("access_token")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "access_token", valid_579036
  var valid_579037 = query.getOrDefault("upload_protocol")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "upload_protocol", valid_579037
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

proc call*(call_579039: Call_ContainerProjectsZonesClustersLegacyAbac_579021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_579039.validator(path, query, header, formData, body)
  let scheme = call_579039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579039.url(scheme.get, call_579039.host, call_579039.base,
                         call_579039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579039, url, valid)

proc call*(call_579040: Call_ContainerProjectsZonesClustersLegacyAbac_579021;
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
  var path_579041 = newJObject()
  var query_579042 = newJObject()
  var body_579043 = newJObject()
  add(query_579042, "key", newJString(key))
  add(query_579042, "prettyPrint", newJBool(prettyPrint))
  add(query_579042, "oauth_token", newJString(oauthToken))
  add(path_579041, "projectId", newJString(projectId))
  add(query_579042, "$.xgafv", newJString(Xgafv))
  add(query_579042, "alt", newJString(alt))
  add(query_579042, "uploadType", newJString(uploadType))
  add(query_579042, "quotaUser", newJString(quotaUser))
  add(path_579041, "clusterId", newJString(clusterId))
  add(path_579041, "zone", newJString(zone))
  if body != nil:
    body_579043 = body
  add(query_579042, "callback", newJString(callback))
  add(query_579042, "fields", newJString(fields))
  add(query_579042, "access_token", newJString(accessToken))
  add(query_579042, "upload_protocol", newJString(uploadProtocol))
  result = call_579040.call(path_579041, query_579042, nil, nil, body_579043)

var containerProjectsZonesClustersLegacyAbac* = Call_ContainerProjectsZonesClustersLegacyAbac_579021(
    name: "containerProjectsZonesClustersLegacyAbac", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/legacyAbac",
    validator: validate_ContainerProjectsZonesClustersLegacyAbac_579022,
    base: "/", url: url_ContainerProjectsZonesClustersLegacyAbac_579023,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLocations_579044 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersLocations_579046(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersLocations_579045(path: JsonNode;
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
  var valid_579047 = path.getOrDefault("projectId")
  valid_579047 = validateParameter(valid_579047, JString, required = true,
                                 default = nil)
  if valid_579047 != nil:
    section.add "projectId", valid_579047
  var valid_579048 = path.getOrDefault("clusterId")
  valid_579048 = validateParameter(valid_579048, JString, required = true,
                                 default = nil)
  if valid_579048 != nil:
    section.add "clusterId", valid_579048
  var valid_579049 = path.getOrDefault("zone")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "zone", valid_579049
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
  var valid_579050 = query.getOrDefault("key")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "key", valid_579050
  var valid_579051 = query.getOrDefault("prettyPrint")
  valid_579051 = validateParameter(valid_579051, JBool, required = false,
                                 default = newJBool(true))
  if valid_579051 != nil:
    section.add "prettyPrint", valid_579051
  var valid_579052 = query.getOrDefault("oauth_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "oauth_token", valid_579052
  var valid_579053 = query.getOrDefault("$.xgafv")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("1"))
  if valid_579053 != nil:
    section.add "$.xgafv", valid_579053
  var valid_579054 = query.getOrDefault("alt")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("json"))
  if valid_579054 != nil:
    section.add "alt", valid_579054
  var valid_579055 = query.getOrDefault("uploadType")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "uploadType", valid_579055
  var valid_579056 = query.getOrDefault("quotaUser")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "quotaUser", valid_579056
  var valid_579057 = query.getOrDefault("callback")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "callback", valid_579057
  var valid_579058 = query.getOrDefault("fields")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "fields", valid_579058
  var valid_579059 = query.getOrDefault("access_token")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "access_token", valid_579059
  var valid_579060 = query.getOrDefault("upload_protocol")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "upload_protocol", valid_579060
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

proc call*(call_579062: Call_ContainerProjectsZonesClustersLocations_579044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_579062.validator(path, query, header, formData, body)
  let scheme = call_579062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579062.url(scheme.get, call_579062.host, call_579062.base,
                         call_579062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579062, url, valid)

proc call*(call_579063: Call_ContainerProjectsZonesClustersLocations_579044;
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
  var path_579064 = newJObject()
  var query_579065 = newJObject()
  var body_579066 = newJObject()
  add(query_579065, "key", newJString(key))
  add(query_579065, "prettyPrint", newJBool(prettyPrint))
  add(query_579065, "oauth_token", newJString(oauthToken))
  add(path_579064, "projectId", newJString(projectId))
  add(query_579065, "$.xgafv", newJString(Xgafv))
  add(query_579065, "alt", newJString(alt))
  add(query_579065, "uploadType", newJString(uploadType))
  add(query_579065, "quotaUser", newJString(quotaUser))
  add(path_579064, "clusterId", newJString(clusterId))
  add(path_579064, "zone", newJString(zone))
  if body != nil:
    body_579066 = body
  add(query_579065, "callback", newJString(callback))
  add(query_579065, "fields", newJString(fields))
  add(query_579065, "access_token", newJString(accessToken))
  add(query_579065, "upload_protocol", newJString(uploadProtocol))
  result = call_579063.call(path_579064, query_579065, nil, nil, body_579066)

var containerProjectsZonesClustersLocations* = Call_ContainerProjectsZonesClustersLocations_579044(
    name: "containerProjectsZonesClustersLocations", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/locations",
    validator: validate_ContainerProjectsZonesClustersLocations_579045, base: "/",
    url: url_ContainerProjectsZonesClustersLocations_579046,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLogging_579067 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersLogging_579069(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersLogging_579068(path: JsonNode;
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
  var valid_579070 = path.getOrDefault("projectId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "projectId", valid_579070
  var valid_579071 = path.getOrDefault("clusterId")
  valid_579071 = validateParameter(valid_579071, JString, required = true,
                                 default = nil)
  if valid_579071 != nil:
    section.add "clusterId", valid_579071
  var valid_579072 = path.getOrDefault("zone")
  valid_579072 = validateParameter(valid_579072, JString, required = true,
                                 default = nil)
  if valid_579072 != nil:
    section.add "zone", valid_579072
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
  var valid_579073 = query.getOrDefault("key")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "key", valid_579073
  var valid_579074 = query.getOrDefault("prettyPrint")
  valid_579074 = validateParameter(valid_579074, JBool, required = false,
                                 default = newJBool(true))
  if valid_579074 != nil:
    section.add "prettyPrint", valid_579074
  var valid_579075 = query.getOrDefault("oauth_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "oauth_token", valid_579075
  var valid_579076 = query.getOrDefault("$.xgafv")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("1"))
  if valid_579076 != nil:
    section.add "$.xgafv", valid_579076
  var valid_579077 = query.getOrDefault("alt")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("json"))
  if valid_579077 != nil:
    section.add "alt", valid_579077
  var valid_579078 = query.getOrDefault("uploadType")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "uploadType", valid_579078
  var valid_579079 = query.getOrDefault("quotaUser")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "quotaUser", valid_579079
  var valid_579080 = query.getOrDefault("callback")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "callback", valid_579080
  var valid_579081 = query.getOrDefault("fields")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "fields", valid_579081
  var valid_579082 = query.getOrDefault("access_token")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "access_token", valid_579082
  var valid_579083 = query.getOrDefault("upload_protocol")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "upload_protocol", valid_579083
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

proc call*(call_579085: Call_ContainerProjectsZonesClustersLogging_579067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_579085.validator(path, query, header, formData, body)
  let scheme = call_579085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579085.url(scheme.get, call_579085.host, call_579085.base,
                         call_579085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579085, url, valid)

proc call*(call_579086: Call_ContainerProjectsZonesClustersLogging_579067;
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
  var path_579087 = newJObject()
  var query_579088 = newJObject()
  var body_579089 = newJObject()
  add(query_579088, "key", newJString(key))
  add(query_579088, "prettyPrint", newJBool(prettyPrint))
  add(query_579088, "oauth_token", newJString(oauthToken))
  add(path_579087, "projectId", newJString(projectId))
  add(query_579088, "$.xgafv", newJString(Xgafv))
  add(query_579088, "alt", newJString(alt))
  add(query_579088, "uploadType", newJString(uploadType))
  add(query_579088, "quotaUser", newJString(quotaUser))
  add(path_579087, "clusterId", newJString(clusterId))
  add(path_579087, "zone", newJString(zone))
  if body != nil:
    body_579089 = body
  add(query_579088, "callback", newJString(callback))
  add(query_579088, "fields", newJString(fields))
  add(query_579088, "access_token", newJString(accessToken))
  add(query_579088, "upload_protocol", newJString(uploadProtocol))
  result = call_579086.call(path_579087, query_579088, nil, nil, body_579089)

var containerProjectsZonesClustersLogging* = Call_ContainerProjectsZonesClustersLogging_579067(
    name: "containerProjectsZonesClustersLogging", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/logging",
    validator: validate_ContainerProjectsZonesClustersLogging_579068, base: "/",
    url: url_ContainerProjectsZonesClustersLogging_579069, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMaster_579090 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersMaster_579092(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersMaster_579091(path: JsonNode;
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
  var valid_579093 = path.getOrDefault("projectId")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "projectId", valid_579093
  var valid_579094 = path.getOrDefault("clusterId")
  valid_579094 = validateParameter(valid_579094, JString, required = true,
                                 default = nil)
  if valid_579094 != nil:
    section.add "clusterId", valid_579094
  var valid_579095 = path.getOrDefault("zone")
  valid_579095 = validateParameter(valid_579095, JString, required = true,
                                 default = nil)
  if valid_579095 != nil:
    section.add "zone", valid_579095
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
  var valid_579096 = query.getOrDefault("key")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "key", valid_579096
  var valid_579097 = query.getOrDefault("prettyPrint")
  valid_579097 = validateParameter(valid_579097, JBool, required = false,
                                 default = newJBool(true))
  if valid_579097 != nil:
    section.add "prettyPrint", valid_579097
  var valid_579098 = query.getOrDefault("oauth_token")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "oauth_token", valid_579098
  var valid_579099 = query.getOrDefault("$.xgafv")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("1"))
  if valid_579099 != nil:
    section.add "$.xgafv", valid_579099
  var valid_579100 = query.getOrDefault("alt")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = newJString("json"))
  if valid_579100 != nil:
    section.add "alt", valid_579100
  var valid_579101 = query.getOrDefault("uploadType")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "uploadType", valid_579101
  var valid_579102 = query.getOrDefault("quotaUser")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "quotaUser", valid_579102
  var valid_579103 = query.getOrDefault("callback")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "callback", valid_579103
  var valid_579104 = query.getOrDefault("fields")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "fields", valid_579104
  var valid_579105 = query.getOrDefault("access_token")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "access_token", valid_579105
  var valid_579106 = query.getOrDefault("upload_protocol")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "upload_protocol", valid_579106
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

proc call*(call_579108: Call_ContainerProjectsZonesClustersMaster_579090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_579108.validator(path, query, header, formData, body)
  let scheme = call_579108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579108.url(scheme.get, call_579108.host, call_579108.base,
                         call_579108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579108, url, valid)

proc call*(call_579109: Call_ContainerProjectsZonesClustersMaster_579090;
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
  var path_579110 = newJObject()
  var query_579111 = newJObject()
  var body_579112 = newJObject()
  add(query_579111, "key", newJString(key))
  add(query_579111, "prettyPrint", newJBool(prettyPrint))
  add(query_579111, "oauth_token", newJString(oauthToken))
  add(path_579110, "projectId", newJString(projectId))
  add(query_579111, "$.xgafv", newJString(Xgafv))
  add(query_579111, "alt", newJString(alt))
  add(query_579111, "uploadType", newJString(uploadType))
  add(query_579111, "quotaUser", newJString(quotaUser))
  add(path_579110, "clusterId", newJString(clusterId))
  add(path_579110, "zone", newJString(zone))
  if body != nil:
    body_579112 = body
  add(query_579111, "callback", newJString(callback))
  add(query_579111, "fields", newJString(fields))
  add(query_579111, "access_token", newJString(accessToken))
  add(query_579111, "upload_protocol", newJString(uploadProtocol))
  result = call_579109.call(path_579110, query_579111, nil, nil, body_579112)

var containerProjectsZonesClustersMaster* = Call_ContainerProjectsZonesClustersMaster_579090(
    name: "containerProjectsZonesClustersMaster", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/master",
    validator: validate_ContainerProjectsZonesClustersMaster_579091, base: "/",
    url: url_ContainerProjectsZonesClustersMaster_579092, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMonitoring_579113 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersMonitoring_579115(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersMonitoring_579114(path: JsonNode;
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
  var valid_579116 = path.getOrDefault("projectId")
  valid_579116 = validateParameter(valid_579116, JString, required = true,
                                 default = nil)
  if valid_579116 != nil:
    section.add "projectId", valid_579116
  var valid_579117 = path.getOrDefault("clusterId")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "clusterId", valid_579117
  var valid_579118 = path.getOrDefault("zone")
  valid_579118 = validateParameter(valid_579118, JString, required = true,
                                 default = nil)
  if valid_579118 != nil:
    section.add "zone", valid_579118
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
  var valid_579119 = query.getOrDefault("key")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "key", valid_579119
  var valid_579120 = query.getOrDefault("prettyPrint")
  valid_579120 = validateParameter(valid_579120, JBool, required = false,
                                 default = newJBool(true))
  if valid_579120 != nil:
    section.add "prettyPrint", valid_579120
  var valid_579121 = query.getOrDefault("oauth_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "oauth_token", valid_579121
  var valid_579122 = query.getOrDefault("$.xgafv")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("1"))
  if valid_579122 != nil:
    section.add "$.xgafv", valid_579122
  var valid_579123 = query.getOrDefault("alt")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = newJString("json"))
  if valid_579123 != nil:
    section.add "alt", valid_579123
  var valid_579124 = query.getOrDefault("uploadType")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "uploadType", valid_579124
  var valid_579125 = query.getOrDefault("quotaUser")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "quotaUser", valid_579125
  var valid_579126 = query.getOrDefault("callback")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "callback", valid_579126
  var valid_579127 = query.getOrDefault("fields")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "fields", valid_579127
  var valid_579128 = query.getOrDefault("access_token")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "access_token", valid_579128
  var valid_579129 = query.getOrDefault("upload_protocol")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "upload_protocol", valid_579129
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

proc call*(call_579131: Call_ContainerProjectsZonesClustersMonitoring_579113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_579131.validator(path, query, header, formData, body)
  let scheme = call_579131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579131.url(scheme.get, call_579131.host, call_579131.base,
                         call_579131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579131, url, valid)

proc call*(call_579132: Call_ContainerProjectsZonesClustersMonitoring_579113;
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
  var path_579133 = newJObject()
  var query_579134 = newJObject()
  var body_579135 = newJObject()
  add(query_579134, "key", newJString(key))
  add(query_579134, "prettyPrint", newJBool(prettyPrint))
  add(query_579134, "oauth_token", newJString(oauthToken))
  add(path_579133, "projectId", newJString(projectId))
  add(query_579134, "$.xgafv", newJString(Xgafv))
  add(query_579134, "alt", newJString(alt))
  add(query_579134, "uploadType", newJString(uploadType))
  add(query_579134, "quotaUser", newJString(quotaUser))
  add(path_579133, "clusterId", newJString(clusterId))
  add(path_579133, "zone", newJString(zone))
  if body != nil:
    body_579135 = body
  add(query_579134, "callback", newJString(callback))
  add(query_579134, "fields", newJString(fields))
  add(query_579134, "access_token", newJString(accessToken))
  add(query_579134, "upload_protocol", newJString(uploadProtocol))
  result = call_579132.call(path_579133, query_579134, nil, nil, body_579135)

var containerProjectsZonesClustersMonitoring* = Call_ContainerProjectsZonesClustersMonitoring_579113(
    name: "containerProjectsZonesClustersMonitoring", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/monitoring",
    validator: validate_ContainerProjectsZonesClustersMonitoring_579114,
    base: "/", url: url_ContainerProjectsZonesClustersMonitoring_579115,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsCreate_579158 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsCreate_579160(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsCreate_579159(
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
  var valid_579161 = path.getOrDefault("projectId")
  valid_579161 = validateParameter(valid_579161, JString, required = true,
                                 default = nil)
  if valid_579161 != nil:
    section.add "projectId", valid_579161
  var valid_579162 = path.getOrDefault("clusterId")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "clusterId", valid_579162
  var valid_579163 = path.getOrDefault("zone")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = nil)
  if valid_579163 != nil:
    section.add "zone", valid_579163
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
  var valid_579164 = query.getOrDefault("key")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "key", valid_579164
  var valid_579165 = query.getOrDefault("prettyPrint")
  valid_579165 = validateParameter(valid_579165, JBool, required = false,
                                 default = newJBool(true))
  if valid_579165 != nil:
    section.add "prettyPrint", valid_579165
  var valid_579166 = query.getOrDefault("oauth_token")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "oauth_token", valid_579166
  var valid_579167 = query.getOrDefault("$.xgafv")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("1"))
  if valid_579167 != nil:
    section.add "$.xgafv", valid_579167
  var valid_579168 = query.getOrDefault("alt")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = newJString("json"))
  if valid_579168 != nil:
    section.add "alt", valid_579168
  var valid_579169 = query.getOrDefault("uploadType")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "uploadType", valid_579169
  var valid_579170 = query.getOrDefault("quotaUser")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "quotaUser", valid_579170
  var valid_579171 = query.getOrDefault("callback")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "callback", valid_579171
  var valid_579172 = query.getOrDefault("fields")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "fields", valid_579172
  var valid_579173 = query.getOrDefault("access_token")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "access_token", valid_579173
  var valid_579174 = query.getOrDefault("upload_protocol")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "upload_protocol", valid_579174
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

proc call*(call_579176: Call_ContainerProjectsZonesClustersNodePoolsCreate_579158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_579176.validator(path, query, header, formData, body)
  let scheme = call_579176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579176.url(scheme.get, call_579176.host, call_579176.base,
                         call_579176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579176, url, valid)

proc call*(call_579177: Call_ContainerProjectsZonesClustersNodePoolsCreate_579158;
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
  var path_579178 = newJObject()
  var query_579179 = newJObject()
  var body_579180 = newJObject()
  add(query_579179, "key", newJString(key))
  add(query_579179, "prettyPrint", newJBool(prettyPrint))
  add(query_579179, "oauth_token", newJString(oauthToken))
  add(path_579178, "projectId", newJString(projectId))
  add(query_579179, "$.xgafv", newJString(Xgafv))
  add(query_579179, "alt", newJString(alt))
  add(query_579179, "uploadType", newJString(uploadType))
  add(query_579179, "quotaUser", newJString(quotaUser))
  add(path_579178, "clusterId", newJString(clusterId))
  add(path_579178, "zone", newJString(zone))
  if body != nil:
    body_579180 = body
  add(query_579179, "callback", newJString(callback))
  add(query_579179, "fields", newJString(fields))
  add(query_579179, "access_token", newJString(accessToken))
  add(query_579179, "upload_protocol", newJString(uploadProtocol))
  result = call_579177.call(path_579178, query_579179, nil, nil, body_579180)

var containerProjectsZonesClustersNodePoolsCreate* = Call_ContainerProjectsZonesClustersNodePoolsCreate_579158(
    name: "containerProjectsZonesClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsCreate_579159,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsCreate_579160,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsList_579136 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsList_579138(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsList_579137(path: JsonNode;
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
  var valid_579139 = path.getOrDefault("projectId")
  valid_579139 = validateParameter(valid_579139, JString, required = true,
                                 default = nil)
  if valid_579139 != nil:
    section.add "projectId", valid_579139
  var valid_579140 = path.getOrDefault("clusterId")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "clusterId", valid_579140
  var valid_579141 = path.getOrDefault("zone")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "zone", valid_579141
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
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("$.xgafv")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("1"))
  if valid_579145 != nil:
    section.add "$.xgafv", valid_579145
  var valid_579146 = query.getOrDefault("alt")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("json"))
  if valid_579146 != nil:
    section.add "alt", valid_579146
  var valid_579147 = query.getOrDefault("uploadType")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "uploadType", valid_579147
  var valid_579148 = query.getOrDefault("parent")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "parent", valid_579148
  var valid_579149 = query.getOrDefault("quotaUser")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "quotaUser", valid_579149
  var valid_579150 = query.getOrDefault("callback")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "callback", valid_579150
  var valid_579151 = query.getOrDefault("fields")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "fields", valid_579151
  var valid_579152 = query.getOrDefault("access_token")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "access_token", valid_579152
  var valid_579153 = query.getOrDefault("upload_protocol")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "upload_protocol", valid_579153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579154: Call_ContainerProjectsZonesClustersNodePoolsList_579136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_579154.validator(path, query, header, formData, body)
  let scheme = call_579154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579154.url(scheme.get, call_579154.host, call_579154.base,
                         call_579154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579154, url, valid)

proc call*(call_579155: Call_ContainerProjectsZonesClustersNodePoolsList_579136;
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
  var path_579156 = newJObject()
  var query_579157 = newJObject()
  add(query_579157, "key", newJString(key))
  add(query_579157, "prettyPrint", newJBool(prettyPrint))
  add(query_579157, "oauth_token", newJString(oauthToken))
  add(path_579156, "projectId", newJString(projectId))
  add(query_579157, "$.xgafv", newJString(Xgafv))
  add(query_579157, "alt", newJString(alt))
  add(query_579157, "uploadType", newJString(uploadType))
  add(query_579157, "parent", newJString(parent))
  add(query_579157, "quotaUser", newJString(quotaUser))
  add(path_579156, "clusterId", newJString(clusterId))
  add(path_579156, "zone", newJString(zone))
  add(query_579157, "callback", newJString(callback))
  add(query_579157, "fields", newJString(fields))
  add(query_579157, "access_token", newJString(accessToken))
  add(query_579157, "upload_protocol", newJString(uploadProtocol))
  result = call_579155.call(path_579156, query_579157, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsList* = Call_ContainerProjectsZonesClustersNodePoolsList_579136(
    name: "containerProjectsZonesClustersNodePoolsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsList_579137,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsList_579138,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsGet_579181 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsGet_579183(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsGet_579182(path: JsonNode;
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
  var valid_579184 = path.getOrDefault("projectId")
  valid_579184 = validateParameter(valid_579184, JString, required = true,
                                 default = nil)
  if valid_579184 != nil:
    section.add "projectId", valid_579184
  var valid_579185 = path.getOrDefault("clusterId")
  valid_579185 = validateParameter(valid_579185, JString, required = true,
                                 default = nil)
  if valid_579185 != nil:
    section.add "clusterId", valid_579185
  var valid_579186 = path.getOrDefault("nodePoolId")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "nodePoolId", valid_579186
  var valid_579187 = path.getOrDefault("zone")
  valid_579187 = validateParameter(valid_579187, JString, required = true,
                                 default = nil)
  if valid_579187 != nil:
    section.add "zone", valid_579187
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
  var valid_579188 = query.getOrDefault("key")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "key", valid_579188
  var valid_579189 = query.getOrDefault("prettyPrint")
  valid_579189 = validateParameter(valid_579189, JBool, required = false,
                                 default = newJBool(true))
  if valid_579189 != nil:
    section.add "prettyPrint", valid_579189
  var valid_579190 = query.getOrDefault("oauth_token")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "oauth_token", valid_579190
  var valid_579191 = query.getOrDefault("name")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "name", valid_579191
  var valid_579192 = query.getOrDefault("$.xgafv")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("1"))
  if valid_579192 != nil:
    section.add "$.xgafv", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("uploadType")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "uploadType", valid_579194
  var valid_579195 = query.getOrDefault("quotaUser")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "quotaUser", valid_579195
  var valid_579196 = query.getOrDefault("callback")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "callback", valid_579196
  var valid_579197 = query.getOrDefault("fields")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "fields", valid_579197
  var valid_579198 = query.getOrDefault("access_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "access_token", valid_579198
  var valid_579199 = query.getOrDefault("upload_protocol")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "upload_protocol", valid_579199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579200: Call_ContainerProjectsZonesClustersNodePoolsGet_579181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_579200.validator(path, query, header, formData, body)
  let scheme = call_579200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579200.url(scheme.get, call_579200.host, call_579200.base,
                         call_579200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579200, url, valid)

proc call*(call_579201: Call_ContainerProjectsZonesClustersNodePoolsGet_579181;
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
  var path_579202 = newJObject()
  var query_579203 = newJObject()
  add(query_579203, "key", newJString(key))
  add(query_579203, "prettyPrint", newJBool(prettyPrint))
  add(query_579203, "oauth_token", newJString(oauthToken))
  add(query_579203, "name", newJString(name))
  add(path_579202, "projectId", newJString(projectId))
  add(query_579203, "$.xgafv", newJString(Xgafv))
  add(query_579203, "alt", newJString(alt))
  add(query_579203, "uploadType", newJString(uploadType))
  add(query_579203, "quotaUser", newJString(quotaUser))
  add(path_579202, "clusterId", newJString(clusterId))
  add(path_579202, "nodePoolId", newJString(nodePoolId))
  add(path_579202, "zone", newJString(zone))
  add(query_579203, "callback", newJString(callback))
  add(query_579203, "fields", newJString(fields))
  add(query_579203, "access_token", newJString(accessToken))
  add(query_579203, "upload_protocol", newJString(uploadProtocol))
  result = call_579201.call(path_579202, query_579203, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsGet* = Call_ContainerProjectsZonesClustersNodePoolsGet_579181(
    name: "containerProjectsZonesClustersNodePoolsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsGet_579182,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsGet_579183,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsDelete_579204 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsDelete_579206(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsDelete_579205(
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
  var valid_579207 = path.getOrDefault("projectId")
  valid_579207 = validateParameter(valid_579207, JString, required = true,
                                 default = nil)
  if valid_579207 != nil:
    section.add "projectId", valid_579207
  var valid_579208 = path.getOrDefault("clusterId")
  valid_579208 = validateParameter(valid_579208, JString, required = true,
                                 default = nil)
  if valid_579208 != nil:
    section.add "clusterId", valid_579208
  var valid_579209 = path.getOrDefault("nodePoolId")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "nodePoolId", valid_579209
  var valid_579210 = path.getOrDefault("zone")
  valid_579210 = validateParameter(valid_579210, JString, required = true,
                                 default = nil)
  if valid_579210 != nil:
    section.add "zone", valid_579210
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
  var valid_579211 = query.getOrDefault("key")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "key", valid_579211
  var valid_579212 = query.getOrDefault("prettyPrint")
  valid_579212 = validateParameter(valid_579212, JBool, required = false,
                                 default = newJBool(true))
  if valid_579212 != nil:
    section.add "prettyPrint", valid_579212
  var valid_579213 = query.getOrDefault("oauth_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "oauth_token", valid_579213
  var valid_579214 = query.getOrDefault("name")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "name", valid_579214
  var valid_579215 = query.getOrDefault("$.xgafv")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = newJString("1"))
  if valid_579215 != nil:
    section.add "$.xgafv", valid_579215
  var valid_579216 = query.getOrDefault("alt")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = newJString("json"))
  if valid_579216 != nil:
    section.add "alt", valid_579216
  var valid_579217 = query.getOrDefault("uploadType")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "uploadType", valid_579217
  var valid_579218 = query.getOrDefault("quotaUser")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "quotaUser", valid_579218
  var valid_579219 = query.getOrDefault("callback")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "callback", valid_579219
  var valid_579220 = query.getOrDefault("fields")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "fields", valid_579220
  var valid_579221 = query.getOrDefault("access_token")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "access_token", valid_579221
  var valid_579222 = query.getOrDefault("upload_protocol")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "upload_protocol", valid_579222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579223: Call_ContainerProjectsZonesClustersNodePoolsDelete_579204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_579223.validator(path, query, header, formData, body)
  let scheme = call_579223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579223.url(scheme.get, call_579223.host, call_579223.base,
                         call_579223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579223, url, valid)

proc call*(call_579224: Call_ContainerProjectsZonesClustersNodePoolsDelete_579204;
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
  var path_579225 = newJObject()
  var query_579226 = newJObject()
  add(query_579226, "key", newJString(key))
  add(query_579226, "prettyPrint", newJBool(prettyPrint))
  add(query_579226, "oauth_token", newJString(oauthToken))
  add(query_579226, "name", newJString(name))
  add(path_579225, "projectId", newJString(projectId))
  add(query_579226, "$.xgafv", newJString(Xgafv))
  add(query_579226, "alt", newJString(alt))
  add(query_579226, "uploadType", newJString(uploadType))
  add(query_579226, "quotaUser", newJString(quotaUser))
  add(path_579225, "clusterId", newJString(clusterId))
  add(path_579225, "nodePoolId", newJString(nodePoolId))
  add(path_579225, "zone", newJString(zone))
  add(query_579226, "callback", newJString(callback))
  add(query_579226, "fields", newJString(fields))
  add(query_579226, "access_token", newJString(accessToken))
  add(query_579226, "upload_protocol", newJString(uploadProtocol))
  result = call_579224.call(path_579225, query_579226, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsDelete* = Call_ContainerProjectsZonesClustersNodePoolsDelete_579204(
    name: "containerProjectsZonesClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsDelete_579205,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsDelete_579206,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_579227 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsAutoscaling_579229(
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

proc validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_579228(
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
  var valid_579230 = path.getOrDefault("projectId")
  valid_579230 = validateParameter(valid_579230, JString, required = true,
                                 default = nil)
  if valid_579230 != nil:
    section.add "projectId", valid_579230
  var valid_579231 = path.getOrDefault("clusterId")
  valid_579231 = validateParameter(valid_579231, JString, required = true,
                                 default = nil)
  if valid_579231 != nil:
    section.add "clusterId", valid_579231
  var valid_579232 = path.getOrDefault("nodePoolId")
  valid_579232 = validateParameter(valid_579232, JString, required = true,
                                 default = nil)
  if valid_579232 != nil:
    section.add "nodePoolId", valid_579232
  var valid_579233 = path.getOrDefault("zone")
  valid_579233 = validateParameter(valid_579233, JString, required = true,
                                 default = nil)
  if valid_579233 != nil:
    section.add "zone", valid_579233
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
  var valid_579234 = query.getOrDefault("key")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "key", valid_579234
  var valid_579235 = query.getOrDefault("prettyPrint")
  valid_579235 = validateParameter(valid_579235, JBool, required = false,
                                 default = newJBool(true))
  if valid_579235 != nil:
    section.add "prettyPrint", valid_579235
  var valid_579236 = query.getOrDefault("oauth_token")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "oauth_token", valid_579236
  var valid_579237 = query.getOrDefault("$.xgafv")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = newJString("1"))
  if valid_579237 != nil:
    section.add "$.xgafv", valid_579237
  var valid_579238 = query.getOrDefault("alt")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = newJString("json"))
  if valid_579238 != nil:
    section.add "alt", valid_579238
  var valid_579239 = query.getOrDefault("uploadType")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "uploadType", valid_579239
  var valid_579240 = query.getOrDefault("quotaUser")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "quotaUser", valid_579240
  var valid_579241 = query.getOrDefault("callback")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "callback", valid_579241
  var valid_579242 = query.getOrDefault("fields")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "fields", valid_579242
  var valid_579243 = query.getOrDefault("access_token")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "access_token", valid_579243
  var valid_579244 = query.getOrDefault("upload_protocol")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "upload_protocol", valid_579244
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

proc call*(call_579246: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_579227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_579246.validator(path, query, header, formData, body)
  let scheme = call_579246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579246.url(scheme.get, call_579246.host, call_579246.base,
                         call_579246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579246, url, valid)

proc call*(call_579247: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_579227;
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
  var path_579248 = newJObject()
  var query_579249 = newJObject()
  var body_579250 = newJObject()
  add(query_579249, "key", newJString(key))
  add(query_579249, "prettyPrint", newJBool(prettyPrint))
  add(query_579249, "oauth_token", newJString(oauthToken))
  add(path_579248, "projectId", newJString(projectId))
  add(query_579249, "$.xgafv", newJString(Xgafv))
  add(query_579249, "alt", newJString(alt))
  add(query_579249, "uploadType", newJString(uploadType))
  add(query_579249, "quotaUser", newJString(quotaUser))
  add(path_579248, "clusterId", newJString(clusterId))
  add(path_579248, "nodePoolId", newJString(nodePoolId))
  add(path_579248, "zone", newJString(zone))
  if body != nil:
    body_579250 = body
  add(query_579249, "callback", newJString(callback))
  add(query_579249, "fields", newJString(fields))
  add(query_579249, "access_token", newJString(accessToken))
  add(query_579249, "upload_protocol", newJString(uploadProtocol))
  result = call_579247.call(path_579248, query_579249, nil, nil, body_579250)

var containerProjectsZonesClustersNodePoolsAutoscaling* = Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_579227(
    name: "containerProjectsZonesClustersNodePoolsAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/autoscaling",
    validator: validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_579228,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsAutoscaling_579229,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetManagement_579251 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsSetManagement_579253(
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

proc validate_ContainerProjectsZonesClustersNodePoolsSetManagement_579252(
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
  var valid_579254 = path.getOrDefault("projectId")
  valid_579254 = validateParameter(valid_579254, JString, required = true,
                                 default = nil)
  if valid_579254 != nil:
    section.add "projectId", valid_579254
  var valid_579255 = path.getOrDefault("clusterId")
  valid_579255 = validateParameter(valid_579255, JString, required = true,
                                 default = nil)
  if valid_579255 != nil:
    section.add "clusterId", valid_579255
  var valid_579256 = path.getOrDefault("nodePoolId")
  valid_579256 = validateParameter(valid_579256, JString, required = true,
                                 default = nil)
  if valid_579256 != nil:
    section.add "nodePoolId", valid_579256
  var valid_579257 = path.getOrDefault("zone")
  valid_579257 = validateParameter(valid_579257, JString, required = true,
                                 default = nil)
  if valid_579257 != nil:
    section.add "zone", valid_579257
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
  var valid_579258 = query.getOrDefault("key")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "key", valid_579258
  var valid_579259 = query.getOrDefault("prettyPrint")
  valid_579259 = validateParameter(valid_579259, JBool, required = false,
                                 default = newJBool(true))
  if valid_579259 != nil:
    section.add "prettyPrint", valid_579259
  var valid_579260 = query.getOrDefault("oauth_token")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "oauth_token", valid_579260
  var valid_579261 = query.getOrDefault("$.xgafv")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = newJString("1"))
  if valid_579261 != nil:
    section.add "$.xgafv", valid_579261
  var valid_579262 = query.getOrDefault("alt")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = newJString("json"))
  if valid_579262 != nil:
    section.add "alt", valid_579262
  var valid_579263 = query.getOrDefault("uploadType")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "uploadType", valid_579263
  var valid_579264 = query.getOrDefault("quotaUser")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "quotaUser", valid_579264
  var valid_579265 = query.getOrDefault("callback")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "callback", valid_579265
  var valid_579266 = query.getOrDefault("fields")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "fields", valid_579266
  var valid_579267 = query.getOrDefault("access_token")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "access_token", valid_579267
  var valid_579268 = query.getOrDefault("upload_protocol")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "upload_protocol", valid_579268
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

proc call*(call_579270: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_579251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_579270.validator(path, query, header, formData, body)
  let scheme = call_579270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579270.url(scheme.get, call_579270.host, call_579270.base,
                         call_579270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579270, url, valid)

proc call*(call_579271: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_579251;
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
  var path_579272 = newJObject()
  var query_579273 = newJObject()
  var body_579274 = newJObject()
  add(query_579273, "key", newJString(key))
  add(query_579273, "prettyPrint", newJBool(prettyPrint))
  add(query_579273, "oauth_token", newJString(oauthToken))
  add(path_579272, "projectId", newJString(projectId))
  add(query_579273, "$.xgafv", newJString(Xgafv))
  add(query_579273, "alt", newJString(alt))
  add(query_579273, "uploadType", newJString(uploadType))
  add(query_579273, "quotaUser", newJString(quotaUser))
  add(path_579272, "clusterId", newJString(clusterId))
  add(path_579272, "nodePoolId", newJString(nodePoolId))
  add(path_579272, "zone", newJString(zone))
  if body != nil:
    body_579274 = body
  add(query_579273, "callback", newJString(callback))
  add(query_579273, "fields", newJString(fields))
  add(query_579273, "access_token", newJString(accessToken))
  add(query_579273, "upload_protocol", newJString(uploadProtocol))
  result = call_579271.call(path_579272, query_579273, nil, nil, body_579274)

var containerProjectsZonesClustersNodePoolsSetManagement* = Call_ContainerProjectsZonesClustersNodePoolsSetManagement_579251(
    name: "containerProjectsZonesClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setManagement",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetManagement_579252,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetManagement_579253,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetSize_579275 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsSetSize_579277(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsSetSize_579276(
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
  var valid_579278 = path.getOrDefault("projectId")
  valid_579278 = validateParameter(valid_579278, JString, required = true,
                                 default = nil)
  if valid_579278 != nil:
    section.add "projectId", valid_579278
  var valid_579279 = path.getOrDefault("clusterId")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "clusterId", valid_579279
  var valid_579280 = path.getOrDefault("nodePoolId")
  valid_579280 = validateParameter(valid_579280, JString, required = true,
                                 default = nil)
  if valid_579280 != nil:
    section.add "nodePoolId", valid_579280
  var valid_579281 = path.getOrDefault("zone")
  valid_579281 = validateParameter(valid_579281, JString, required = true,
                                 default = nil)
  if valid_579281 != nil:
    section.add "zone", valid_579281
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
  var valid_579282 = query.getOrDefault("key")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "key", valid_579282
  var valid_579283 = query.getOrDefault("prettyPrint")
  valid_579283 = validateParameter(valid_579283, JBool, required = false,
                                 default = newJBool(true))
  if valid_579283 != nil:
    section.add "prettyPrint", valid_579283
  var valid_579284 = query.getOrDefault("oauth_token")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "oauth_token", valid_579284
  var valid_579285 = query.getOrDefault("$.xgafv")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = newJString("1"))
  if valid_579285 != nil:
    section.add "$.xgafv", valid_579285
  var valid_579286 = query.getOrDefault("alt")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = newJString("json"))
  if valid_579286 != nil:
    section.add "alt", valid_579286
  var valid_579287 = query.getOrDefault("uploadType")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "uploadType", valid_579287
  var valid_579288 = query.getOrDefault("quotaUser")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "quotaUser", valid_579288
  var valid_579289 = query.getOrDefault("callback")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "callback", valid_579289
  var valid_579290 = query.getOrDefault("fields")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "fields", valid_579290
  var valid_579291 = query.getOrDefault("access_token")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "access_token", valid_579291
  var valid_579292 = query.getOrDefault("upload_protocol")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "upload_protocol", valid_579292
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

proc call*(call_579294: Call_ContainerProjectsZonesClustersNodePoolsSetSize_579275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_579294.validator(path, query, header, formData, body)
  let scheme = call_579294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579294.url(scheme.get, call_579294.host, call_579294.base,
                         call_579294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579294, url, valid)

proc call*(call_579295: Call_ContainerProjectsZonesClustersNodePoolsSetSize_579275;
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
  var path_579296 = newJObject()
  var query_579297 = newJObject()
  var body_579298 = newJObject()
  add(query_579297, "key", newJString(key))
  add(query_579297, "prettyPrint", newJBool(prettyPrint))
  add(query_579297, "oauth_token", newJString(oauthToken))
  add(path_579296, "projectId", newJString(projectId))
  add(query_579297, "$.xgafv", newJString(Xgafv))
  add(query_579297, "alt", newJString(alt))
  add(query_579297, "uploadType", newJString(uploadType))
  add(query_579297, "quotaUser", newJString(quotaUser))
  add(path_579296, "clusterId", newJString(clusterId))
  add(path_579296, "nodePoolId", newJString(nodePoolId))
  add(path_579296, "zone", newJString(zone))
  if body != nil:
    body_579298 = body
  add(query_579297, "callback", newJString(callback))
  add(query_579297, "fields", newJString(fields))
  add(query_579297, "access_token", newJString(accessToken))
  add(query_579297, "upload_protocol", newJString(uploadProtocol))
  result = call_579295.call(path_579296, query_579297, nil, nil, body_579298)

var containerProjectsZonesClustersNodePoolsSetSize* = Call_ContainerProjectsZonesClustersNodePoolsSetSize_579275(
    name: "containerProjectsZonesClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setSize",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetSize_579276,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetSize_579277,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsUpdate_579299 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsUpdate_579301(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsUpdate_579300(
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
  var valid_579302 = path.getOrDefault("projectId")
  valid_579302 = validateParameter(valid_579302, JString, required = true,
                                 default = nil)
  if valid_579302 != nil:
    section.add "projectId", valid_579302
  var valid_579303 = path.getOrDefault("clusterId")
  valid_579303 = validateParameter(valid_579303, JString, required = true,
                                 default = nil)
  if valid_579303 != nil:
    section.add "clusterId", valid_579303
  var valid_579304 = path.getOrDefault("nodePoolId")
  valid_579304 = validateParameter(valid_579304, JString, required = true,
                                 default = nil)
  if valid_579304 != nil:
    section.add "nodePoolId", valid_579304
  var valid_579305 = path.getOrDefault("zone")
  valid_579305 = validateParameter(valid_579305, JString, required = true,
                                 default = nil)
  if valid_579305 != nil:
    section.add "zone", valid_579305
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
  var valid_579306 = query.getOrDefault("key")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "key", valid_579306
  var valid_579307 = query.getOrDefault("prettyPrint")
  valid_579307 = validateParameter(valid_579307, JBool, required = false,
                                 default = newJBool(true))
  if valid_579307 != nil:
    section.add "prettyPrint", valid_579307
  var valid_579308 = query.getOrDefault("oauth_token")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "oauth_token", valid_579308
  var valid_579309 = query.getOrDefault("$.xgafv")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = newJString("1"))
  if valid_579309 != nil:
    section.add "$.xgafv", valid_579309
  var valid_579310 = query.getOrDefault("alt")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = newJString("json"))
  if valid_579310 != nil:
    section.add "alt", valid_579310
  var valid_579311 = query.getOrDefault("uploadType")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "uploadType", valid_579311
  var valid_579312 = query.getOrDefault("quotaUser")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "quotaUser", valid_579312
  var valid_579313 = query.getOrDefault("callback")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "callback", valid_579313
  var valid_579314 = query.getOrDefault("fields")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "fields", valid_579314
  var valid_579315 = query.getOrDefault("access_token")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "access_token", valid_579315
  var valid_579316 = query.getOrDefault("upload_protocol")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "upload_protocol", valid_579316
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

proc call*(call_579318: Call_ContainerProjectsZonesClustersNodePoolsUpdate_579299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_579318.validator(path, query, header, formData, body)
  let scheme = call_579318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579318.url(scheme.get, call_579318.host, call_579318.base,
                         call_579318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579318, url, valid)

proc call*(call_579319: Call_ContainerProjectsZonesClustersNodePoolsUpdate_579299;
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
  var path_579320 = newJObject()
  var query_579321 = newJObject()
  var body_579322 = newJObject()
  add(query_579321, "key", newJString(key))
  add(query_579321, "prettyPrint", newJBool(prettyPrint))
  add(query_579321, "oauth_token", newJString(oauthToken))
  add(path_579320, "projectId", newJString(projectId))
  add(query_579321, "$.xgafv", newJString(Xgafv))
  add(query_579321, "alt", newJString(alt))
  add(query_579321, "uploadType", newJString(uploadType))
  add(query_579321, "quotaUser", newJString(quotaUser))
  add(path_579320, "clusterId", newJString(clusterId))
  add(path_579320, "nodePoolId", newJString(nodePoolId))
  add(path_579320, "zone", newJString(zone))
  if body != nil:
    body_579322 = body
  add(query_579321, "callback", newJString(callback))
  add(query_579321, "fields", newJString(fields))
  add(query_579321, "access_token", newJString(accessToken))
  add(query_579321, "upload_protocol", newJString(uploadProtocol))
  result = call_579319.call(path_579320, query_579321, nil, nil, body_579322)

var containerProjectsZonesClustersNodePoolsUpdate* = Call_ContainerProjectsZonesClustersNodePoolsUpdate_579299(
    name: "containerProjectsZonesClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/update",
    validator: validate_ContainerProjectsZonesClustersNodePoolsUpdate_579300,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsUpdate_579301,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsRollback_579323 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsRollback_579325(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsRollback_579324(
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
  var valid_579326 = path.getOrDefault("projectId")
  valid_579326 = validateParameter(valid_579326, JString, required = true,
                                 default = nil)
  if valid_579326 != nil:
    section.add "projectId", valid_579326
  var valid_579327 = path.getOrDefault("clusterId")
  valid_579327 = validateParameter(valid_579327, JString, required = true,
                                 default = nil)
  if valid_579327 != nil:
    section.add "clusterId", valid_579327
  var valid_579328 = path.getOrDefault("nodePoolId")
  valid_579328 = validateParameter(valid_579328, JString, required = true,
                                 default = nil)
  if valid_579328 != nil:
    section.add "nodePoolId", valid_579328
  var valid_579329 = path.getOrDefault("zone")
  valid_579329 = validateParameter(valid_579329, JString, required = true,
                                 default = nil)
  if valid_579329 != nil:
    section.add "zone", valid_579329
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
  var valid_579330 = query.getOrDefault("key")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "key", valid_579330
  var valid_579331 = query.getOrDefault("prettyPrint")
  valid_579331 = validateParameter(valid_579331, JBool, required = false,
                                 default = newJBool(true))
  if valid_579331 != nil:
    section.add "prettyPrint", valid_579331
  var valid_579332 = query.getOrDefault("oauth_token")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "oauth_token", valid_579332
  var valid_579333 = query.getOrDefault("$.xgafv")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = newJString("1"))
  if valid_579333 != nil:
    section.add "$.xgafv", valid_579333
  var valid_579334 = query.getOrDefault("alt")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = newJString("json"))
  if valid_579334 != nil:
    section.add "alt", valid_579334
  var valid_579335 = query.getOrDefault("uploadType")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "uploadType", valid_579335
  var valid_579336 = query.getOrDefault("quotaUser")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "quotaUser", valid_579336
  var valid_579337 = query.getOrDefault("callback")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "callback", valid_579337
  var valid_579338 = query.getOrDefault("fields")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "fields", valid_579338
  var valid_579339 = query.getOrDefault("access_token")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "access_token", valid_579339
  var valid_579340 = query.getOrDefault("upload_protocol")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "upload_protocol", valid_579340
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

proc call*(call_579342: Call_ContainerProjectsZonesClustersNodePoolsRollback_579323;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_579342.validator(path, query, header, formData, body)
  let scheme = call_579342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579342.url(scheme.get, call_579342.host, call_579342.base,
                         call_579342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579342, url, valid)

proc call*(call_579343: Call_ContainerProjectsZonesClustersNodePoolsRollback_579323;
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
  var path_579344 = newJObject()
  var query_579345 = newJObject()
  var body_579346 = newJObject()
  add(query_579345, "key", newJString(key))
  add(query_579345, "prettyPrint", newJBool(prettyPrint))
  add(query_579345, "oauth_token", newJString(oauthToken))
  add(path_579344, "projectId", newJString(projectId))
  add(query_579345, "$.xgafv", newJString(Xgafv))
  add(query_579345, "alt", newJString(alt))
  add(query_579345, "uploadType", newJString(uploadType))
  add(query_579345, "quotaUser", newJString(quotaUser))
  add(path_579344, "clusterId", newJString(clusterId))
  add(path_579344, "nodePoolId", newJString(nodePoolId))
  add(path_579344, "zone", newJString(zone))
  if body != nil:
    body_579346 = body
  add(query_579345, "callback", newJString(callback))
  add(query_579345, "fields", newJString(fields))
  add(query_579345, "access_token", newJString(accessToken))
  add(query_579345, "upload_protocol", newJString(uploadProtocol))
  result = call_579343.call(path_579344, query_579345, nil, nil, body_579346)

var containerProjectsZonesClustersNodePoolsRollback* = Call_ContainerProjectsZonesClustersNodePoolsRollback_579323(
    name: "containerProjectsZonesClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}:rollback",
    validator: validate_ContainerProjectsZonesClustersNodePoolsRollback_579324,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsRollback_579325,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersResourceLabels_579347 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersResourceLabels_579349(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersResourceLabels_579348(path: JsonNode;
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
  var valid_579350 = path.getOrDefault("projectId")
  valid_579350 = validateParameter(valid_579350, JString, required = true,
                                 default = nil)
  if valid_579350 != nil:
    section.add "projectId", valid_579350
  var valid_579351 = path.getOrDefault("clusterId")
  valid_579351 = validateParameter(valid_579351, JString, required = true,
                                 default = nil)
  if valid_579351 != nil:
    section.add "clusterId", valid_579351
  var valid_579352 = path.getOrDefault("zone")
  valid_579352 = validateParameter(valid_579352, JString, required = true,
                                 default = nil)
  if valid_579352 != nil:
    section.add "zone", valid_579352
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
  var valid_579353 = query.getOrDefault("key")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "key", valid_579353
  var valid_579354 = query.getOrDefault("prettyPrint")
  valid_579354 = validateParameter(valid_579354, JBool, required = false,
                                 default = newJBool(true))
  if valid_579354 != nil:
    section.add "prettyPrint", valid_579354
  var valid_579355 = query.getOrDefault("oauth_token")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "oauth_token", valid_579355
  var valid_579356 = query.getOrDefault("$.xgafv")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = newJString("1"))
  if valid_579356 != nil:
    section.add "$.xgafv", valid_579356
  var valid_579357 = query.getOrDefault("alt")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = newJString("json"))
  if valid_579357 != nil:
    section.add "alt", valid_579357
  var valid_579358 = query.getOrDefault("uploadType")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "uploadType", valid_579358
  var valid_579359 = query.getOrDefault("quotaUser")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "quotaUser", valid_579359
  var valid_579360 = query.getOrDefault("callback")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "callback", valid_579360
  var valid_579361 = query.getOrDefault("fields")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "fields", valid_579361
  var valid_579362 = query.getOrDefault("access_token")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "access_token", valid_579362
  var valid_579363 = query.getOrDefault("upload_protocol")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "upload_protocol", valid_579363
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

proc call*(call_579365: Call_ContainerProjectsZonesClustersResourceLabels_579347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_579365.validator(path, query, header, formData, body)
  let scheme = call_579365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579365.url(scheme.get, call_579365.host, call_579365.base,
                         call_579365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579365, url, valid)

proc call*(call_579366: Call_ContainerProjectsZonesClustersResourceLabels_579347;
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
  var path_579367 = newJObject()
  var query_579368 = newJObject()
  var body_579369 = newJObject()
  add(query_579368, "key", newJString(key))
  add(query_579368, "prettyPrint", newJBool(prettyPrint))
  add(query_579368, "oauth_token", newJString(oauthToken))
  add(path_579367, "projectId", newJString(projectId))
  add(query_579368, "$.xgafv", newJString(Xgafv))
  add(query_579368, "alt", newJString(alt))
  add(query_579368, "uploadType", newJString(uploadType))
  add(query_579368, "quotaUser", newJString(quotaUser))
  add(path_579367, "clusterId", newJString(clusterId))
  add(path_579367, "zone", newJString(zone))
  if body != nil:
    body_579369 = body
  add(query_579368, "callback", newJString(callback))
  add(query_579368, "fields", newJString(fields))
  add(query_579368, "access_token", newJString(accessToken))
  add(query_579368, "upload_protocol", newJString(uploadProtocol))
  result = call_579366.call(path_579367, query_579368, nil, nil, body_579369)

var containerProjectsZonesClustersResourceLabels* = Call_ContainerProjectsZonesClustersResourceLabels_579347(
    name: "containerProjectsZonesClustersResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/resourceLabels",
    validator: validate_ContainerProjectsZonesClustersResourceLabels_579348,
    base: "/", url: url_ContainerProjectsZonesClustersResourceLabels_579349,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersCompleteIpRotation_579370 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersCompleteIpRotation_579372(
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

proc validate_ContainerProjectsZonesClustersCompleteIpRotation_579371(
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
  var valid_579373 = path.getOrDefault("projectId")
  valid_579373 = validateParameter(valid_579373, JString, required = true,
                                 default = nil)
  if valid_579373 != nil:
    section.add "projectId", valid_579373
  var valid_579374 = path.getOrDefault("clusterId")
  valid_579374 = validateParameter(valid_579374, JString, required = true,
                                 default = nil)
  if valid_579374 != nil:
    section.add "clusterId", valid_579374
  var valid_579375 = path.getOrDefault("zone")
  valid_579375 = validateParameter(valid_579375, JString, required = true,
                                 default = nil)
  if valid_579375 != nil:
    section.add "zone", valid_579375
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
  var valid_579376 = query.getOrDefault("key")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "key", valid_579376
  var valid_579377 = query.getOrDefault("prettyPrint")
  valid_579377 = validateParameter(valid_579377, JBool, required = false,
                                 default = newJBool(true))
  if valid_579377 != nil:
    section.add "prettyPrint", valid_579377
  var valid_579378 = query.getOrDefault("oauth_token")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "oauth_token", valid_579378
  var valid_579379 = query.getOrDefault("$.xgafv")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = newJString("1"))
  if valid_579379 != nil:
    section.add "$.xgafv", valid_579379
  var valid_579380 = query.getOrDefault("alt")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = newJString("json"))
  if valid_579380 != nil:
    section.add "alt", valid_579380
  var valid_579381 = query.getOrDefault("uploadType")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "uploadType", valid_579381
  var valid_579382 = query.getOrDefault("quotaUser")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "quotaUser", valid_579382
  var valid_579383 = query.getOrDefault("callback")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "callback", valid_579383
  var valid_579384 = query.getOrDefault("fields")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "fields", valid_579384
  var valid_579385 = query.getOrDefault("access_token")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "access_token", valid_579385
  var valid_579386 = query.getOrDefault("upload_protocol")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "upload_protocol", valid_579386
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

proc call*(call_579388: Call_ContainerProjectsZonesClustersCompleteIpRotation_579370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_579388.validator(path, query, header, formData, body)
  let scheme = call_579388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579388.url(scheme.get, call_579388.host, call_579388.base,
                         call_579388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579388, url, valid)

proc call*(call_579389: Call_ContainerProjectsZonesClustersCompleteIpRotation_579370;
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
  var path_579390 = newJObject()
  var query_579391 = newJObject()
  var body_579392 = newJObject()
  add(query_579391, "key", newJString(key))
  add(query_579391, "prettyPrint", newJBool(prettyPrint))
  add(query_579391, "oauth_token", newJString(oauthToken))
  add(path_579390, "projectId", newJString(projectId))
  add(query_579391, "$.xgafv", newJString(Xgafv))
  add(query_579391, "alt", newJString(alt))
  add(query_579391, "uploadType", newJString(uploadType))
  add(query_579391, "quotaUser", newJString(quotaUser))
  add(path_579390, "clusterId", newJString(clusterId))
  add(path_579390, "zone", newJString(zone))
  if body != nil:
    body_579392 = body
  add(query_579391, "callback", newJString(callback))
  add(query_579391, "fields", newJString(fields))
  add(query_579391, "access_token", newJString(accessToken))
  add(query_579391, "upload_protocol", newJString(uploadProtocol))
  result = call_579389.call(path_579390, query_579391, nil, nil, body_579392)

var containerProjectsZonesClustersCompleteIpRotation* = Call_ContainerProjectsZonesClustersCompleteIpRotation_579370(
    name: "containerProjectsZonesClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:completeIpRotation",
    validator: validate_ContainerProjectsZonesClustersCompleteIpRotation_579371,
    base: "/", url: url_ContainerProjectsZonesClustersCompleteIpRotation_579372,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMaintenancePolicy_579393 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersSetMaintenancePolicy_579395(
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

proc validate_ContainerProjectsZonesClustersSetMaintenancePolicy_579394(
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
  var valid_579396 = path.getOrDefault("projectId")
  valid_579396 = validateParameter(valid_579396, JString, required = true,
                                 default = nil)
  if valid_579396 != nil:
    section.add "projectId", valid_579396
  var valid_579397 = path.getOrDefault("clusterId")
  valid_579397 = validateParameter(valid_579397, JString, required = true,
                                 default = nil)
  if valid_579397 != nil:
    section.add "clusterId", valid_579397
  var valid_579398 = path.getOrDefault("zone")
  valid_579398 = validateParameter(valid_579398, JString, required = true,
                                 default = nil)
  if valid_579398 != nil:
    section.add "zone", valid_579398
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
  var valid_579399 = query.getOrDefault("key")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "key", valid_579399
  var valid_579400 = query.getOrDefault("prettyPrint")
  valid_579400 = validateParameter(valid_579400, JBool, required = false,
                                 default = newJBool(true))
  if valid_579400 != nil:
    section.add "prettyPrint", valid_579400
  var valid_579401 = query.getOrDefault("oauth_token")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "oauth_token", valid_579401
  var valid_579402 = query.getOrDefault("$.xgafv")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = newJString("1"))
  if valid_579402 != nil:
    section.add "$.xgafv", valid_579402
  var valid_579403 = query.getOrDefault("alt")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = newJString("json"))
  if valid_579403 != nil:
    section.add "alt", valid_579403
  var valid_579404 = query.getOrDefault("uploadType")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "uploadType", valid_579404
  var valid_579405 = query.getOrDefault("quotaUser")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "quotaUser", valid_579405
  var valid_579406 = query.getOrDefault("callback")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "callback", valid_579406
  var valid_579407 = query.getOrDefault("fields")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "fields", valid_579407
  var valid_579408 = query.getOrDefault("access_token")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "access_token", valid_579408
  var valid_579409 = query.getOrDefault("upload_protocol")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "upload_protocol", valid_579409
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

proc call*(call_579411: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_579393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_579411.validator(path, query, header, formData, body)
  let scheme = call_579411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579411.url(scheme.get, call_579411.host, call_579411.base,
                         call_579411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579411, url, valid)

proc call*(call_579412: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_579393;
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
  var path_579413 = newJObject()
  var query_579414 = newJObject()
  var body_579415 = newJObject()
  add(query_579414, "key", newJString(key))
  add(query_579414, "prettyPrint", newJBool(prettyPrint))
  add(query_579414, "oauth_token", newJString(oauthToken))
  add(path_579413, "projectId", newJString(projectId))
  add(query_579414, "$.xgafv", newJString(Xgafv))
  add(query_579414, "alt", newJString(alt))
  add(query_579414, "uploadType", newJString(uploadType))
  add(query_579414, "quotaUser", newJString(quotaUser))
  add(path_579413, "clusterId", newJString(clusterId))
  add(path_579413, "zone", newJString(zone))
  if body != nil:
    body_579415 = body
  add(query_579414, "callback", newJString(callback))
  add(query_579414, "fields", newJString(fields))
  add(query_579414, "access_token", newJString(accessToken))
  add(query_579414, "upload_protocol", newJString(uploadProtocol))
  result = call_579412.call(path_579413, query_579414, nil, nil, body_579415)

var containerProjectsZonesClustersSetMaintenancePolicy* = Call_ContainerProjectsZonesClustersSetMaintenancePolicy_579393(
    name: "containerProjectsZonesClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMaintenancePolicy",
    validator: validate_ContainerProjectsZonesClustersSetMaintenancePolicy_579394,
    base: "/", url: url_ContainerProjectsZonesClustersSetMaintenancePolicy_579395,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMasterAuth_579416 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersSetMasterAuth_579418(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersSetMasterAuth_579417(path: JsonNode;
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
  var valid_579419 = path.getOrDefault("projectId")
  valid_579419 = validateParameter(valid_579419, JString, required = true,
                                 default = nil)
  if valid_579419 != nil:
    section.add "projectId", valid_579419
  var valid_579420 = path.getOrDefault("clusterId")
  valid_579420 = validateParameter(valid_579420, JString, required = true,
                                 default = nil)
  if valid_579420 != nil:
    section.add "clusterId", valid_579420
  var valid_579421 = path.getOrDefault("zone")
  valid_579421 = validateParameter(valid_579421, JString, required = true,
                                 default = nil)
  if valid_579421 != nil:
    section.add "zone", valid_579421
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
  var valid_579422 = query.getOrDefault("key")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "key", valid_579422
  var valid_579423 = query.getOrDefault("prettyPrint")
  valid_579423 = validateParameter(valid_579423, JBool, required = false,
                                 default = newJBool(true))
  if valid_579423 != nil:
    section.add "prettyPrint", valid_579423
  var valid_579424 = query.getOrDefault("oauth_token")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "oauth_token", valid_579424
  var valid_579425 = query.getOrDefault("$.xgafv")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = newJString("1"))
  if valid_579425 != nil:
    section.add "$.xgafv", valid_579425
  var valid_579426 = query.getOrDefault("alt")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = newJString("json"))
  if valid_579426 != nil:
    section.add "alt", valid_579426
  var valid_579427 = query.getOrDefault("uploadType")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "uploadType", valid_579427
  var valid_579428 = query.getOrDefault("quotaUser")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "quotaUser", valid_579428
  var valid_579429 = query.getOrDefault("callback")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "callback", valid_579429
  var valid_579430 = query.getOrDefault("fields")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "fields", valid_579430
  var valid_579431 = query.getOrDefault("access_token")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "access_token", valid_579431
  var valid_579432 = query.getOrDefault("upload_protocol")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "upload_protocol", valid_579432
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

proc call*(call_579434: Call_ContainerProjectsZonesClustersSetMasterAuth_579416;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_579434.validator(path, query, header, formData, body)
  let scheme = call_579434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579434.url(scheme.get, call_579434.host, call_579434.base,
                         call_579434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579434, url, valid)

proc call*(call_579435: Call_ContainerProjectsZonesClustersSetMasterAuth_579416;
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
  var path_579436 = newJObject()
  var query_579437 = newJObject()
  var body_579438 = newJObject()
  add(query_579437, "key", newJString(key))
  add(query_579437, "prettyPrint", newJBool(prettyPrint))
  add(query_579437, "oauth_token", newJString(oauthToken))
  add(path_579436, "projectId", newJString(projectId))
  add(query_579437, "$.xgafv", newJString(Xgafv))
  add(query_579437, "alt", newJString(alt))
  add(query_579437, "uploadType", newJString(uploadType))
  add(query_579437, "quotaUser", newJString(quotaUser))
  add(path_579436, "clusterId", newJString(clusterId))
  add(path_579436, "zone", newJString(zone))
  if body != nil:
    body_579438 = body
  add(query_579437, "callback", newJString(callback))
  add(query_579437, "fields", newJString(fields))
  add(query_579437, "access_token", newJString(accessToken))
  add(query_579437, "upload_protocol", newJString(uploadProtocol))
  result = call_579435.call(path_579436, query_579437, nil, nil, body_579438)

var containerProjectsZonesClustersSetMasterAuth* = Call_ContainerProjectsZonesClustersSetMasterAuth_579416(
    name: "containerProjectsZonesClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMasterAuth",
    validator: validate_ContainerProjectsZonesClustersSetMasterAuth_579417,
    base: "/", url: url_ContainerProjectsZonesClustersSetMasterAuth_579418,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetNetworkPolicy_579439 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersSetNetworkPolicy_579441(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersSetNetworkPolicy_579440(
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
  var valid_579442 = path.getOrDefault("projectId")
  valid_579442 = validateParameter(valid_579442, JString, required = true,
                                 default = nil)
  if valid_579442 != nil:
    section.add "projectId", valid_579442
  var valid_579443 = path.getOrDefault("clusterId")
  valid_579443 = validateParameter(valid_579443, JString, required = true,
                                 default = nil)
  if valid_579443 != nil:
    section.add "clusterId", valid_579443
  var valid_579444 = path.getOrDefault("zone")
  valid_579444 = validateParameter(valid_579444, JString, required = true,
                                 default = nil)
  if valid_579444 != nil:
    section.add "zone", valid_579444
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
  var valid_579445 = query.getOrDefault("key")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "key", valid_579445
  var valid_579446 = query.getOrDefault("prettyPrint")
  valid_579446 = validateParameter(valid_579446, JBool, required = false,
                                 default = newJBool(true))
  if valid_579446 != nil:
    section.add "prettyPrint", valid_579446
  var valid_579447 = query.getOrDefault("oauth_token")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "oauth_token", valid_579447
  var valid_579448 = query.getOrDefault("$.xgafv")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = newJString("1"))
  if valid_579448 != nil:
    section.add "$.xgafv", valid_579448
  var valid_579449 = query.getOrDefault("alt")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = newJString("json"))
  if valid_579449 != nil:
    section.add "alt", valid_579449
  var valid_579450 = query.getOrDefault("uploadType")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "uploadType", valid_579450
  var valid_579451 = query.getOrDefault("quotaUser")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "quotaUser", valid_579451
  var valid_579452 = query.getOrDefault("callback")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "callback", valid_579452
  var valid_579453 = query.getOrDefault("fields")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "fields", valid_579453
  var valid_579454 = query.getOrDefault("access_token")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "access_token", valid_579454
  var valid_579455 = query.getOrDefault("upload_protocol")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = nil)
  if valid_579455 != nil:
    section.add "upload_protocol", valid_579455
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

proc call*(call_579457: Call_ContainerProjectsZonesClustersSetNetworkPolicy_579439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_579457.validator(path, query, header, formData, body)
  let scheme = call_579457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579457.url(scheme.get, call_579457.host, call_579457.base,
                         call_579457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579457, url, valid)

proc call*(call_579458: Call_ContainerProjectsZonesClustersSetNetworkPolicy_579439;
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
  var path_579459 = newJObject()
  var query_579460 = newJObject()
  var body_579461 = newJObject()
  add(query_579460, "key", newJString(key))
  add(query_579460, "prettyPrint", newJBool(prettyPrint))
  add(query_579460, "oauth_token", newJString(oauthToken))
  add(path_579459, "projectId", newJString(projectId))
  add(query_579460, "$.xgafv", newJString(Xgafv))
  add(query_579460, "alt", newJString(alt))
  add(query_579460, "uploadType", newJString(uploadType))
  add(query_579460, "quotaUser", newJString(quotaUser))
  add(path_579459, "clusterId", newJString(clusterId))
  add(path_579459, "zone", newJString(zone))
  if body != nil:
    body_579461 = body
  add(query_579460, "callback", newJString(callback))
  add(query_579460, "fields", newJString(fields))
  add(query_579460, "access_token", newJString(accessToken))
  add(query_579460, "upload_protocol", newJString(uploadProtocol))
  result = call_579458.call(path_579459, query_579460, nil, nil, body_579461)

var containerProjectsZonesClustersSetNetworkPolicy* = Call_ContainerProjectsZonesClustersSetNetworkPolicy_579439(
    name: "containerProjectsZonesClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setNetworkPolicy",
    validator: validate_ContainerProjectsZonesClustersSetNetworkPolicy_579440,
    base: "/", url: url_ContainerProjectsZonesClustersSetNetworkPolicy_579441,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersStartIpRotation_579462 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersStartIpRotation_579464(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersStartIpRotation_579463(
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
  var valid_579465 = path.getOrDefault("projectId")
  valid_579465 = validateParameter(valid_579465, JString, required = true,
                                 default = nil)
  if valid_579465 != nil:
    section.add "projectId", valid_579465
  var valid_579466 = path.getOrDefault("clusterId")
  valid_579466 = validateParameter(valid_579466, JString, required = true,
                                 default = nil)
  if valid_579466 != nil:
    section.add "clusterId", valid_579466
  var valid_579467 = path.getOrDefault("zone")
  valid_579467 = validateParameter(valid_579467, JString, required = true,
                                 default = nil)
  if valid_579467 != nil:
    section.add "zone", valid_579467
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
  var valid_579468 = query.getOrDefault("key")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "key", valid_579468
  var valid_579469 = query.getOrDefault("prettyPrint")
  valid_579469 = validateParameter(valid_579469, JBool, required = false,
                                 default = newJBool(true))
  if valid_579469 != nil:
    section.add "prettyPrint", valid_579469
  var valid_579470 = query.getOrDefault("oauth_token")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "oauth_token", valid_579470
  var valid_579471 = query.getOrDefault("$.xgafv")
  valid_579471 = validateParameter(valid_579471, JString, required = false,
                                 default = newJString("1"))
  if valid_579471 != nil:
    section.add "$.xgafv", valid_579471
  var valid_579472 = query.getOrDefault("alt")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = newJString("json"))
  if valid_579472 != nil:
    section.add "alt", valid_579472
  var valid_579473 = query.getOrDefault("uploadType")
  valid_579473 = validateParameter(valid_579473, JString, required = false,
                                 default = nil)
  if valid_579473 != nil:
    section.add "uploadType", valid_579473
  var valid_579474 = query.getOrDefault("quotaUser")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "quotaUser", valid_579474
  var valid_579475 = query.getOrDefault("callback")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = nil)
  if valid_579475 != nil:
    section.add "callback", valid_579475
  var valid_579476 = query.getOrDefault("fields")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "fields", valid_579476
  var valid_579477 = query.getOrDefault("access_token")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "access_token", valid_579477
  var valid_579478 = query.getOrDefault("upload_protocol")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "upload_protocol", valid_579478
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

proc call*(call_579480: Call_ContainerProjectsZonesClustersStartIpRotation_579462;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_579480.validator(path, query, header, formData, body)
  let scheme = call_579480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579480.url(scheme.get, call_579480.host, call_579480.base,
                         call_579480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579480, url, valid)

proc call*(call_579481: Call_ContainerProjectsZonesClustersStartIpRotation_579462;
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
  var path_579482 = newJObject()
  var query_579483 = newJObject()
  var body_579484 = newJObject()
  add(query_579483, "key", newJString(key))
  add(query_579483, "prettyPrint", newJBool(prettyPrint))
  add(query_579483, "oauth_token", newJString(oauthToken))
  add(path_579482, "projectId", newJString(projectId))
  add(query_579483, "$.xgafv", newJString(Xgafv))
  add(query_579483, "alt", newJString(alt))
  add(query_579483, "uploadType", newJString(uploadType))
  add(query_579483, "quotaUser", newJString(quotaUser))
  add(path_579482, "clusterId", newJString(clusterId))
  add(path_579482, "zone", newJString(zone))
  if body != nil:
    body_579484 = body
  add(query_579483, "callback", newJString(callback))
  add(query_579483, "fields", newJString(fields))
  add(query_579483, "access_token", newJString(accessToken))
  add(query_579483, "upload_protocol", newJString(uploadProtocol))
  result = call_579481.call(path_579482, query_579483, nil, nil, body_579484)

var containerProjectsZonesClustersStartIpRotation* = Call_ContainerProjectsZonesClustersStartIpRotation_579462(
    name: "containerProjectsZonesClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:startIpRotation",
    validator: validate_ContainerProjectsZonesClustersStartIpRotation_579463,
    base: "/", url: url_ContainerProjectsZonesClustersStartIpRotation_579464,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsList_579485 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesOperationsList_579487(protocol: Scheme;
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

proc validate_ContainerProjectsZonesOperationsList_579486(path: JsonNode;
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
  var valid_579488 = path.getOrDefault("projectId")
  valid_579488 = validateParameter(valid_579488, JString, required = true,
                                 default = nil)
  if valid_579488 != nil:
    section.add "projectId", valid_579488
  var valid_579489 = path.getOrDefault("zone")
  valid_579489 = validateParameter(valid_579489, JString, required = true,
                                 default = nil)
  if valid_579489 != nil:
    section.add "zone", valid_579489
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
  var valid_579490 = query.getOrDefault("key")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "key", valid_579490
  var valid_579491 = query.getOrDefault("prettyPrint")
  valid_579491 = validateParameter(valid_579491, JBool, required = false,
                                 default = newJBool(true))
  if valid_579491 != nil:
    section.add "prettyPrint", valid_579491
  var valid_579492 = query.getOrDefault("oauth_token")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "oauth_token", valid_579492
  var valid_579493 = query.getOrDefault("$.xgafv")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = newJString("1"))
  if valid_579493 != nil:
    section.add "$.xgafv", valid_579493
  var valid_579494 = query.getOrDefault("alt")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = newJString("json"))
  if valid_579494 != nil:
    section.add "alt", valid_579494
  var valid_579495 = query.getOrDefault("uploadType")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = nil)
  if valid_579495 != nil:
    section.add "uploadType", valid_579495
  var valid_579496 = query.getOrDefault("parent")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "parent", valid_579496
  var valid_579497 = query.getOrDefault("quotaUser")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "quotaUser", valid_579497
  var valid_579498 = query.getOrDefault("callback")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "callback", valid_579498
  var valid_579499 = query.getOrDefault("fields")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "fields", valid_579499
  var valid_579500 = query.getOrDefault("access_token")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "access_token", valid_579500
  var valid_579501 = query.getOrDefault("upload_protocol")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "upload_protocol", valid_579501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579502: Call_ContainerProjectsZonesOperationsList_579485;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_579502.validator(path, query, header, formData, body)
  let scheme = call_579502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579502.url(scheme.get, call_579502.host, call_579502.base,
                         call_579502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579502, url, valid)

proc call*(call_579503: Call_ContainerProjectsZonesOperationsList_579485;
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
  var path_579504 = newJObject()
  var query_579505 = newJObject()
  add(query_579505, "key", newJString(key))
  add(query_579505, "prettyPrint", newJBool(prettyPrint))
  add(query_579505, "oauth_token", newJString(oauthToken))
  add(path_579504, "projectId", newJString(projectId))
  add(query_579505, "$.xgafv", newJString(Xgafv))
  add(query_579505, "alt", newJString(alt))
  add(query_579505, "uploadType", newJString(uploadType))
  add(query_579505, "parent", newJString(parent))
  add(query_579505, "quotaUser", newJString(quotaUser))
  add(path_579504, "zone", newJString(zone))
  add(query_579505, "callback", newJString(callback))
  add(query_579505, "fields", newJString(fields))
  add(query_579505, "access_token", newJString(accessToken))
  add(query_579505, "upload_protocol", newJString(uploadProtocol))
  result = call_579503.call(path_579504, query_579505, nil, nil, nil)

var containerProjectsZonesOperationsList* = Call_ContainerProjectsZonesOperationsList_579485(
    name: "containerProjectsZonesOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations",
    validator: validate_ContainerProjectsZonesOperationsList_579486, base: "/",
    url: url_ContainerProjectsZonesOperationsList_579487, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsGet_579506 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesOperationsGet_579508(protocol: Scheme; host: string;
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

proc validate_ContainerProjectsZonesOperationsGet_579507(path: JsonNode;
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
  var valid_579509 = path.getOrDefault("projectId")
  valid_579509 = validateParameter(valid_579509, JString, required = true,
                                 default = nil)
  if valid_579509 != nil:
    section.add "projectId", valid_579509
  var valid_579510 = path.getOrDefault("operationId")
  valid_579510 = validateParameter(valid_579510, JString, required = true,
                                 default = nil)
  if valid_579510 != nil:
    section.add "operationId", valid_579510
  var valid_579511 = path.getOrDefault("zone")
  valid_579511 = validateParameter(valid_579511, JString, required = true,
                                 default = nil)
  if valid_579511 != nil:
    section.add "zone", valid_579511
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
  var valid_579512 = query.getOrDefault("key")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "key", valid_579512
  var valid_579513 = query.getOrDefault("prettyPrint")
  valid_579513 = validateParameter(valid_579513, JBool, required = false,
                                 default = newJBool(true))
  if valid_579513 != nil:
    section.add "prettyPrint", valid_579513
  var valid_579514 = query.getOrDefault("oauth_token")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "oauth_token", valid_579514
  var valid_579515 = query.getOrDefault("name")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "name", valid_579515
  var valid_579516 = query.getOrDefault("$.xgafv")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = newJString("1"))
  if valid_579516 != nil:
    section.add "$.xgafv", valid_579516
  var valid_579517 = query.getOrDefault("alt")
  valid_579517 = validateParameter(valid_579517, JString, required = false,
                                 default = newJString("json"))
  if valid_579517 != nil:
    section.add "alt", valid_579517
  var valid_579518 = query.getOrDefault("uploadType")
  valid_579518 = validateParameter(valid_579518, JString, required = false,
                                 default = nil)
  if valid_579518 != nil:
    section.add "uploadType", valid_579518
  var valid_579519 = query.getOrDefault("quotaUser")
  valid_579519 = validateParameter(valid_579519, JString, required = false,
                                 default = nil)
  if valid_579519 != nil:
    section.add "quotaUser", valid_579519
  var valid_579520 = query.getOrDefault("callback")
  valid_579520 = validateParameter(valid_579520, JString, required = false,
                                 default = nil)
  if valid_579520 != nil:
    section.add "callback", valid_579520
  var valid_579521 = query.getOrDefault("fields")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "fields", valid_579521
  var valid_579522 = query.getOrDefault("access_token")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = nil)
  if valid_579522 != nil:
    section.add "access_token", valid_579522
  var valid_579523 = query.getOrDefault("upload_protocol")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = nil)
  if valid_579523 != nil:
    section.add "upload_protocol", valid_579523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579524: Call_ContainerProjectsZonesOperationsGet_579506;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified operation.
  ## 
  let valid = call_579524.validator(path, query, header, formData, body)
  let scheme = call_579524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579524.url(scheme.get, call_579524.host, call_579524.base,
                         call_579524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579524, url, valid)

proc call*(call_579525: Call_ContainerProjectsZonesOperationsGet_579506;
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
  var path_579526 = newJObject()
  var query_579527 = newJObject()
  add(query_579527, "key", newJString(key))
  add(query_579527, "prettyPrint", newJBool(prettyPrint))
  add(query_579527, "oauth_token", newJString(oauthToken))
  add(query_579527, "name", newJString(name))
  add(path_579526, "projectId", newJString(projectId))
  add(query_579527, "$.xgafv", newJString(Xgafv))
  add(path_579526, "operationId", newJString(operationId))
  add(query_579527, "alt", newJString(alt))
  add(query_579527, "uploadType", newJString(uploadType))
  add(query_579527, "quotaUser", newJString(quotaUser))
  add(path_579526, "zone", newJString(zone))
  add(query_579527, "callback", newJString(callback))
  add(query_579527, "fields", newJString(fields))
  add(query_579527, "access_token", newJString(accessToken))
  add(query_579527, "upload_protocol", newJString(uploadProtocol))
  result = call_579525.call(path_579526, query_579527, nil, nil, nil)

var containerProjectsZonesOperationsGet* = Call_ContainerProjectsZonesOperationsGet_579506(
    name: "containerProjectsZonesOperationsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}",
    validator: validate_ContainerProjectsZonesOperationsGet_579507, base: "/",
    url: url_ContainerProjectsZonesOperationsGet_579508, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsCancel_579528 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesOperationsCancel_579530(protocol: Scheme;
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

proc validate_ContainerProjectsZonesOperationsCancel_579529(path: JsonNode;
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
  var valid_579531 = path.getOrDefault("projectId")
  valid_579531 = validateParameter(valid_579531, JString, required = true,
                                 default = nil)
  if valid_579531 != nil:
    section.add "projectId", valid_579531
  var valid_579532 = path.getOrDefault("operationId")
  valid_579532 = validateParameter(valid_579532, JString, required = true,
                                 default = nil)
  if valid_579532 != nil:
    section.add "operationId", valid_579532
  var valid_579533 = path.getOrDefault("zone")
  valid_579533 = validateParameter(valid_579533, JString, required = true,
                                 default = nil)
  if valid_579533 != nil:
    section.add "zone", valid_579533
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
  var valid_579534 = query.getOrDefault("key")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "key", valid_579534
  var valid_579535 = query.getOrDefault("prettyPrint")
  valid_579535 = validateParameter(valid_579535, JBool, required = false,
                                 default = newJBool(true))
  if valid_579535 != nil:
    section.add "prettyPrint", valid_579535
  var valid_579536 = query.getOrDefault("oauth_token")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = nil)
  if valid_579536 != nil:
    section.add "oauth_token", valid_579536
  var valid_579537 = query.getOrDefault("$.xgafv")
  valid_579537 = validateParameter(valid_579537, JString, required = false,
                                 default = newJString("1"))
  if valid_579537 != nil:
    section.add "$.xgafv", valid_579537
  var valid_579538 = query.getOrDefault("alt")
  valid_579538 = validateParameter(valid_579538, JString, required = false,
                                 default = newJString("json"))
  if valid_579538 != nil:
    section.add "alt", valid_579538
  var valid_579539 = query.getOrDefault("uploadType")
  valid_579539 = validateParameter(valid_579539, JString, required = false,
                                 default = nil)
  if valid_579539 != nil:
    section.add "uploadType", valid_579539
  var valid_579540 = query.getOrDefault("quotaUser")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "quotaUser", valid_579540
  var valid_579541 = query.getOrDefault("callback")
  valid_579541 = validateParameter(valid_579541, JString, required = false,
                                 default = nil)
  if valid_579541 != nil:
    section.add "callback", valid_579541
  var valid_579542 = query.getOrDefault("fields")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "fields", valid_579542
  var valid_579543 = query.getOrDefault("access_token")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "access_token", valid_579543
  var valid_579544 = query.getOrDefault("upload_protocol")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "upload_protocol", valid_579544
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

proc call*(call_579546: Call_ContainerProjectsZonesOperationsCancel_579528;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_579546.validator(path, query, header, formData, body)
  let scheme = call_579546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579546.url(scheme.get, call_579546.host, call_579546.base,
                         call_579546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579546, url, valid)

proc call*(call_579547: Call_ContainerProjectsZonesOperationsCancel_579528;
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
  var path_579548 = newJObject()
  var query_579549 = newJObject()
  var body_579550 = newJObject()
  add(query_579549, "key", newJString(key))
  add(query_579549, "prettyPrint", newJBool(prettyPrint))
  add(query_579549, "oauth_token", newJString(oauthToken))
  add(path_579548, "projectId", newJString(projectId))
  add(query_579549, "$.xgafv", newJString(Xgafv))
  add(path_579548, "operationId", newJString(operationId))
  add(query_579549, "alt", newJString(alt))
  add(query_579549, "uploadType", newJString(uploadType))
  add(query_579549, "quotaUser", newJString(quotaUser))
  add(path_579548, "zone", newJString(zone))
  if body != nil:
    body_579550 = body
  add(query_579549, "callback", newJString(callback))
  add(query_579549, "fields", newJString(fields))
  add(query_579549, "access_token", newJString(accessToken))
  add(query_579549, "upload_protocol", newJString(uploadProtocol))
  result = call_579547.call(path_579548, query_579549, nil, nil, body_579550)

var containerProjectsZonesOperationsCancel* = Call_ContainerProjectsZonesOperationsCancel_579528(
    name: "containerProjectsZonesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}:cancel",
    validator: validate_ContainerProjectsZonesOperationsCancel_579529, base: "/",
    url: url_ContainerProjectsZonesOperationsCancel_579530,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesGetServerconfig_579551 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesGetServerconfig_579553(protocol: Scheme;
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

proc validate_ContainerProjectsZonesGetServerconfig_579552(path: JsonNode;
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
  var valid_579554 = path.getOrDefault("projectId")
  valid_579554 = validateParameter(valid_579554, JString, required = true,
                                 default = nil)
  if valid_579554 != nil:
    section.add "projectId", valid_579554
  var valid_579555 = path.getOrDefault("zone")
  valid_579555 = validateParameter(valid_579555, JString, required = true,
                                 default = nil)
  if valid_579555 != nil:
    section.add "zone", valid_579555
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
  var valid_579556 = query.getOrDefault("key")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "key", valid_579556
  var valid_579557 = query.getOrDefault("prettyPrint")
  valid_579557 = validateParameter(valid_579557, JBool, required = false,
                                 default = newJBool(true))
  if valid_579557 != nil:
    section.add "prettyPrint", valid_579557
  var valid_579558 = query.getOrDefault("oauth_token")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = nil)
  if valid_579558 != nil:
    section.add "oauth_token", valid_579558
  var valid_579559 = query.getOrDefault("name")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "name", valid_579559
  var valid_579560 = query.getOrDefault("$.xgafv")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = newJString("1"))
  if valid_579560 != nil:
    section.add "$.xgafv", valid_579560
  var valid_579561 = query.getOrDefault("alt")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = newJString("json"))
  if valid_579561 != nil:
    section.add "alt", valid_579561
  var valid_579562 = query.getOrDefault("uploadType")
  valid_579562 = validateParameter(valid_579562, JString, required = false,
                                 default = nil)
  if valid_579562 != nil:
    section.add "uploadType", valid_579562
  var valid_579563 = query.getOrDefault("quotaUser")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "quotaUser", valid_579563
  var valid_579564 = query.getOrDefault("callback")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "callback", valid_579564
  var valid_579565 = query.getOrDefault("fields")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "fields", valid_579565
  var valid_579566 = query.getOrDefault("access_token")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = nil)
  if valid_579566 != nil:
    section.add "access_token", valid_579566
  var valid_579567 = query.getOrDefault("upload_protocol")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = nil)
  if valid_579567 != nil:
    section.add "upload_protocol", valid_579567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579568: Call_ContainerProjectsZonesGetServerconfig_579551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_579568.validator(path, query, header, formData, body)
  let scheme = call_579568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579568.url(scheme.get, call_579568.host, call_579568.base,
                         call_579568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579568, url, valid)

proc call*(call_579569: Call_ContainerProjectsZonesGetServerconfig_579551;
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
  var path_579570 = newJObject()
  var query_579571 = newJObject()
  add(query_579571, "key", newJString(key))
  add(query_579571, "prettyPrint", newJBool(prettyPrint))
  add(query_579571, "oauth_token", newJString(oauthToken))
  add(query_579571, "name", newJString(name))
  add(path_579570, "projectId", newJString(projectId))
  add(query_579571, "$.xgafv", newJString(Xgafv))
  add(query_579571, "alt", newJString(alt))
  add(query_579571, "uploadType", newJString(uploadType))
  add(query_579571, "quotaUser", newJString(quotaUser))
  add(path_579570, "zone", newJString(zone))
  add(query_579571, "callback", newJString(callback))
  add(query_579571, "fields", newJString(fields))
  add(query_579571, "access_token", newJString(accessToken))
  add(query_579571, "upload_protocol", newJString(uploadProtocol))
  result = call_579569.call(path_579570, query_579571, nil, nil, nil)

var containerProjectsZonesGetServerconfig* = Call_ContainerProjectsZonesGetServerconfig_579551(
    name: "containerProjectsZonesGetServerconfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/serverconfig",
    validator: validate_ContainerProjectsZonesGetServerconfig_579552, base: "/",
    url: url_ContainerProjectsZonesGetServerconfig_579553, schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsUpdate_579595 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsUpdate_579597(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsUpdate_579596(
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
  var valid_579598 = path.getOrDefault("name")
  valid_579598 = validateParameter(valid_579598, JString, required = true,
                                 default = nil)
  if valid_579598 != nil:
    section.add "name", valid_579598
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
  var valid_579599 = query.getOrDefault("key")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "key", valid_579599
  var valid_579600 = query.getOrDefault("prettyPrint")
  valid_579600 = validateParameter(valid_579600, JBool, required = false,
                                 default = newJBool(true))
  if valid_579600 != nil:
    section.add "prettyPrint", valid_579600
  var valid_579601 = query.getOrDefault("oauth_token")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "oauth_token", valid_579601
  var valid_579602 = query.getOrDefault("$.xgafv")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = newJString("1"))
  if valid_579602 != nil:
    section.add "$.xgafv", valid_579602
  var valid_579603 = query.getOrDefault("alt")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = newJString("json"))
  if valid_579603 != nil:
    section.add "alt", valid_579603
  var valid_579604 = query.getOrDefault("uploadType")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "uploadType", valid_579604
  var valid_579605 = query.getOrDefault("quotaUser")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = nil)
  if valid_579605 != nil:
    section.add "quotaUser", valid_579605
  var valid_579606 = query.getOrDefault("callback")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "callback", valid_579606
  var valid_579607 = query.getOrDefault("fields")
  valid_579607 = validateParameter(valid_579607, JString, required = false,
                                 default = nil)
  if valid_579607 != nil:
    section.add "fields", valid_579607
  var valid_579608 = query.getOrDefault("access_token")
  valid_579608 = validateParameter(valid_579608, JString, required = false,
                                 default = nil)
  if valid_579608 != nil:
    section.add "access_token", valid_579608
  var valid_579609 = query.getOrDefault("upload_protocol")
  valid_579609 = validateParameter(valid_579609, JString, required = false,
                                 default = nil)
  if valid_579609 != nil:
    section.add "upload_protocol", valid_579609
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

proc call*(call_579611: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_579595;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_579611.validator(path, query, header, formData, body)
  let scheme = call_579611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579611.url(scheme.get, call_579611.host, call_579611.base,
                         call_579611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579611, url, valid)

proc call*(call_579612: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_579595;
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
  var path_579613 = newJObject()
  var query_579614 = newJObject()
  var body_579615 = newJObject()
  add(query_579614, "key", newJString(key))
  add(query_579614, "prettyPrint", newJBool(prettyPrint))
  add(query_579614, "oauth_token", newJString(oauthToken))
  add(query_579614, "$.xgafv", newJString(Xgafv))
  add(query_579614, "alt", newJString(alt))
  add(query_579614, "uploadType", newJString(uploadType))
  add(query_579614, "quotaUser", newJString(quotaUser))
  add(path_579613, "name", newJString(name))
  if body != nil:
    body_579615 = body
  add(query_579614, "callback", newJString(callback))
  add(query_579614, "fields", newJString(fields))
  add(query_579614, "access_token", newJString(accessToken))
  add(query_579614, "upload_protocol", newJString(uploadProtocol))
  result = call_579612.call(path_579613, query_579614, nil, nil, body_579615)

var containerProjectsLocationsClustersNodePoolsUpdate* = Call_ContainerProjectsLocationsClustersNodePoolsUpdate_579595(
    name: "containerProjectsLocationsClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPut, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsUpdate_579596,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsUpdate_579597,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsGet_579572 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsGet_579574(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersNodePoolsGet_579573(
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
  var valid_579575 = path.getOrDefault("name")
  valid_579575 = validateParameter(valid_579575, JString, required = true,
                                 default = nil)
  if valid_579575 != nil:
    section.add "name", valid_579575
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
  var valid_579576 = query.getOrDefault("key")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = nil)
  if valid_579576 != nil:
    section.add "key", valid_579576
  var valid_579577 = query.getOrDefault("prettyPrint")
  valid_579577 = validateParameter(valid_579577, JBool, required = false,
                                 default = newJBool(true))
  if valid_579577 != nil:
    section.add "prettyPrint", valid_579577
  var valid_579578 = query.getOrDefault("oauth_token")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = nil)
  if valid_579578 != nil:
    section.add "oauth_token", valid_579578
  var valid_579579 = query.getOrDefault("$.xgafv")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = newJString("1"))
  if valid_579579 != nil:
    section.add "$.xgafv", valid_579579
  var valid_579580 = query.getOrDefault("alt")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = newJString("json"))
  if valid_579580 != nil:
    section.add "alt", valid_579580
  var valid_579581 = query.getOrDefault("uploadType")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "uploadType", valid_579581
  var valid_579582 = query.getOrDefault("quotaUser")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "quotaUser", valid_579582
  var valid_579583 = query.getOrDefault("nodePoolId")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = nil)
  if valid_579583 != nil:
    section.add "nodePoolId", valid_579583
  var valid_579584 = query.getOrDefault("clusterId")
  valid_579584 = validateParameter(valid_579584, JString, required = false,
                                 default = nil)
  if valid_579584 != nil:
    section.add "clusterId", valid_579584
  var valid_579585 = query.getOrDefault("zone")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = nil)
  if valid_579585 != nil:
    section.add "zone", valid_579585
  var valid_579586 = query.getOrDefault("callback")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = nil)
  if valid_579586 != nil:
    section.add "callback", valid_579586
  var valid_579587 = query.getOrDefault("fields")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "fields", valid_579587
  var valid_579588 = query.getOrDefault("access_token")
  valid_579588 = validateParameter(valid_579588, JString, required = false,
                                 default = nil)
  if valid_579588 != nil:
    section.add "access_token", valid_579588
  var valid_579589 = query.getOrDefault("upload_protocol")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "upload_protocol", valid_579589
  var valid_579590 = query.getOrDefault("projectId")
  valid_579590 = validateParameter(valid_579590, JString, required = false,
                                 default = nil)
  if valid_579590 != nil:
    section.add "projectId", valid_579590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579591: Call_ContainerProjectsLocationsClustersNodePoolsGet_579572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_579591.validator(path, query, header, formData, body)
  let scheme = call_579591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579591.url(scheme.get, call_579591.host, call_579591.base,
                         call_579591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579591, url, valid)

proc call*(call_579592: Call_ContainerProjectsLocationsClustersNodePoolsGet_579572;
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
  var path_579593 = newJObject()
  var query_579594 = newJObject()
  add(query_579594, "key", newJString(key))
  add(query_579594, "prettyPrint", newJBool(prettyPrint))
  add(query_579594, "oauth_token", newJString(oauthToken))
  add(query_579594, "$.xgafv", newJString(Xgafv))
  add(query_579594, "alt", newJString(alt))
  add(query_579594, "uploadType", newJString(uploadType))
  add(query_579594, "quotaUser", newJString(quotaUser))
  add(path_579593, "name", newJString(name))
  add(query_579594, "nodePoolId", newJString(nodePoolId))
  add(query_579594, "clusterId", newJString(clusterId))
  add(query_579594, "zone", newJString(zone))
  add(query_579594, "callback", newJString(callback))
  add(query_579594, "fields", newJString(fields))
  add(query_579594, "access_token", newJString(accessToken))
  add(query_579594, "upload_protocol", newJString(uploadProtocol))
  add(query_579594, "projectId", newJString(projectId))
  result = call_579592.call(path_579593, query_579594, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsGet* = Call_ContainerProjectsLocationsClustersNodePoolsGet_579572(
    name: "containerProjectsLocationsClustersNodePoolsGet",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsGet_579573,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsGet_579574,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsDelete_579616 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsDelete_579618(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsDelete_579617(
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
  var valid_579619 = path.getOrDefault("name")
  valid_579619 = validateParameter(valid_579619, JString, required = true,
                                 default = nil)
  if valid_579619 != nil:
    section.add "name", valid_579619
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
  var valid_579620 = query.getOrDefault("key")
  valid_579620 = validateParameter(valid_579620, JString, required = false,
                                 default = nil)
  if valid_579620 != nil:
    section.add "key", valid_579620
  var valid_579621 = query.getOrDefault("prettyPrint")
  valid_579621 = validateParameter(valid_579621, JBool, required = false,
                                 default = newJBool(true))
  if valid_579621 != nil:
    section.add "prettyPrint", valid_579621
  var valid_579622 = query.getOrDefault("oauth_token")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "oauth_token", valid_579622
  var valid_579623 = query.getOrDefault("$.xgafv")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = newJString("1"))
  if valid_579623 != nil:
    section.add "$.xgafv", valid_579623
  var valid_579624 = query.getOrDefault("alt")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = newJString("json"))
  if valid_579624 != nil:
    section.add "alt", valid_579624
  var valid_579625 = query.getOrDefault("uploadType")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "uploadType", valid_579625
  var valid_579626 = query.getOrDefault("quotaUser")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "quotaUser", valid_579626
  var valid_579627 = query.getOrDefault("nodePoolId")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "nodePoolId", valid_579627
  var valid_579628 = query.getOrDefault("clusterId")
  valid_579628 = validateParameter(valid_579628, JString, required = false,
                                 default = nil)
  if valid_579628 != nil:
    section.add "clusterId", valid_579628
  var valid_579629 = query.getOrDefault("zone")
  valid_579629 = validateParameter(valid_579629, JString, required = false,
                                 default = nil)
  if valid_579629 != nil:
    section.add "zone", valid_579629
  var valid_579630 = query.getOrDefault("callback")
  valid_579630 = validateParameter(valid_579630, JString, required = false,
                                 default = nil)
  if valid_579630 != nil:
    section.add "callback", valid_579630
  var valid_579631 = query.getOrDefault("fields")
  valid_579631 = validateParameter(valid_579631, JString, required = false,
                                 default = nil)
  if valid_579631 != nil:
    section.add "fields", valid_579631
  var valid_579632 = query.getOrDefault("access_token")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "access_token", valid_579632
  var valid_579633 = query.getOrDefault("upload_protocol")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = nil)
  if valid_579633 != nil:
    section.add "upload_protocol", valid_579633
  var valid_579634 = query.getOrDefault("projectId")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = nil)
  if valid_579634 != nil:
    section.add "projectId", valid_579634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579635: Call_ContainerProjectsLocationsClustersNodePoolsDelete_579616;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_579635.validator(path, query, header, formData, body)
  let scheme = call_579635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579635.url(scheme.get, call_579635.host, call_579635.base,
                         call_579635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579635, url, valid)

proc call*(call_579636: Call_ContainerProjectsLocationsClustersNodePoolsDelete_579616;
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
  var path_579637 = newJObject()
  var query_579638 = newJObject()
  add(query_579638, "key", newJString(key))
  add(query_579638, "prettyPrint", newJBool(prettyPrint))
  add(query_579638, "oauth_token", newJString(oauthToken))
  add(query_579638, "$.xgafv", newJString(Xgafv))
  add(query_579638, "alt", newJString(alt))
  add(query_579638, "uploadType", newJString(uploadType))
  add(query_579638, "quotaUser", newJString(quotaUser))
  add(path_579637, "name", newJString(name))
  add(query_579638, "nodePoolId", newJString(nodePoolId))
  add(query_579638, "clusterId", newJString(clusterId))
  add(query_579638, "zone", newJString(zone))
  add(query_579638, "callback", newJString(callback))
  add(query_579638, "fields", newJString(fields))
  add(query_579638, "access_token", newJString(accessToken))
  add(query_579638, "upload_protocol", newJString(uploadProtocol))
  add(query_579638, "projectId", newJString(projectId))
  result = call_579636.call(path_579637, query_579638, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsDelete* = Call_ContainerProjectsLocationsClustersNodePoolsDelete_579616(
    name: "containerProjectsLocationsClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsDelete_579617,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsDelete_579618,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsGetServerConfig_579639 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsGetServerConfig_579641(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsGetServerConfig_579640(path: JsonNode;
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
  var valid_579642 = path.getOrDefault("name")
  valid_579642 = validateParameter(valid_579642, JString, required = true,
                                 default = nil)
  if valid_579642 != nil:
    section.add "name", valid_579642
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
  var valid_579643 = query.getOrDefault("key")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "key", valid_579643
  var valid_579644 = query.getOrDefault("prettyPrint")
  valid_579644 = validateParameter(valid_579644, JBool, required = false,
                                 default = newJBool(true))
  if valid_579644 != nil:
    section.add "prettyPrint", valid_579644
  var valid_579645 = query.getOrDefault("oauth_token")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "oauth_token", valid_579645
  var valid_579646 = query.getOrDefault("$.xgafv")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = newJString("1"))
  if valid_579646 != nil:
    section.add "$.xgafv", valid_579646
  var valid_579647 = query.getOrDefault("alt")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = newJString("json"))
  if valid_579647 != nil:
    section.add "alt", valid_579647
  var valid_579648 = query.getOrDefault("uploadType")
  valid_579648 = validateParameter(valid_579648, JString, required = false,
                                 default = nil)
  if valid_579648 != nil:
    section.add "uploadType", valid_579648
  var valid_579649 = query.getOrDefault("quotaUser")
  valid_579649 = validateParameter(valid_579649, JString, required = false,
                                 default = nil)
  if valid_579649 != nil:
    section.add "quotaUser", valid_579649
  var valid_579650 = query.getOrDefault("zone")
  valid_579650 = validateParameter(valid_579650, JString, required = false,
                                 default = nil)
  if valid_579650 != nil:
    section.add "zone", valid_579650
  var valid_579651 = query.getOrDefault("callback")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "callback", valid_579651
  var valid_579652 = query.getOrDefault("fields")
  valid_579652 = validateParameter(valid_579652, JString, required = false,
                                 default = nil)
  if valid_579652 != nil:
    section.add "fields", valid_579652
  var valid_579653 = query.getOrDefault("access_token")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "access_token", valid_579653
  var valid_579654 = query.getOrDefault("upload_protocol")
  valid_579654 = validateParameter(valid_579654, JString, required = false,
                                 default = nil)
  if valid_579654 != nil:
    section.add "upload_protocol", valid_579654
  var valid_579655 = query.getOrDefault("projectId")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "projectId", valid_579655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579656: Call_ContainerProjectsLocationsGetServerConfig_579639;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_579656.validator(path, query, header, formData, body)
  let scheme = call_579656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579656.url(scheme.get, call_579656.host, call_579656.base,
                         call_579656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579656, url, valid)

proc call*(call_579657: Call_ContainerProjectsLocationsGetServerConfig_579639;
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
  var path_579658 = newJObject()
  var query_579659 = newJObject()
  add(query_579659, "key", newJString(key))
  add(query_579659, "prettyPrint", newJBool(prettyPrint))
  add(query_579659, "oauth_token", newJString(oauthToken))
  add(query_579659, "$.xgafv", newJString(Xgafv))
  add(query_579659, "alt", newJString(alt))
  add(query_579659, "uploadType", newJString(uploadType))
  add(query_579659, "quotaUser", newJString(quotaUser))
  add(path_579658, "name", newJString(name))
  add(query_579659, "zone", newJString(zone))
  add(query_579659, "callback", newJString(callback))
  add(query_579659, "fields", newJString(fields))
  add(query_579659, "access_token", newJString(accessToken))
  add(query_579659, "upload_protocol", newJString(uploadProtocol))
  add(query_579659, "projectId", newJString(projectId))
  result = call_579657.call(path_579658, query_579659, nil, nil, nil)

var containerProjectsLocationsGetServerConfig* = Call_ContainerProjectsLocationsGetServerConfig_579639(
    name: "containerProjectsLocationsGetServerConfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{name}/serverConfig",
    validator: validate_ContainerProjectsLocationsGetServerConfig_579640,
    base: "/", url: url_ContainerProjectsLocationsGetServerConfig_579641,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsCancel_579660 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsOperationsCancel_579662(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsOperationsCancel_579661(path: JsonNode;
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
  var valid_579663 = path.getOrDefault("name")
  valid_579663 = validateParameter(valid_579663, JString, required = true,
                                 default = nil)
  if valid_579663 != nil:
    section.add "name", valid_579663
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
  var valid_579664 = query.getOrDefault("key")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "key", valid_579664
  var valid_579665 = query.getOrDefault("prettyPrint")
  valid_579665 = validateParameter(valid_579665, JBool, required = false,
                                 default = newJBool(true))
  if valid_579665 != nil:
    section.add "prettyPrint", valid_579665
  var valid_579666 = query.getOrDefault("oauth_token")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = nil)
  if valid_579666 != nil:
    section.add "oauth_token", valid_579666
  var valid_579667 = query.getOrDefault("$.xgafv")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = newJString("1"))
  if valid_579667 != nil:
    section.add "$.xgafv", valid_579667
  var valid_579668 = query.getOrDefault("alt")
  valid_579668 = validateParameter(valid_579668, JString, required = false,
                                 default = newJString("json"))
  if valid_579668 != nil:
    section.add "alt", valid_579668
  var valid_579669 = query.getOrDefault("uploadType")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = nil)
  if valid_579669 != nil:
    section.add "uploadType", valid_579669
  var valid_579670 = query.getOrDefault("quotaUser")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "quotaUser", valid_579670
  var valid_579671 = query.getOrDefault("callback")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "callback", valid_579671
  var valid_579672 = query.getOrDefault("fields")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "fields", valid_579672
  var valid_579673 = query.getOrDefault("access_token")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "access_token", valid_579673
  var valid_579674 = query.getOrDefault("upload_protocol")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "upload_protocol", valid_579674
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

proc call*(call_579676: Call_ContainerProjectsLocationsOperationsCancel_579660;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_579676.validator(path, query, header, formData, body)
  let scheme = call_579676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579676.url(scheme.get, call_579676.host, call_579676.base,
                         call_579676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579676, url, valid)

proc call*(call_579677: Call_ContainerProjectsLocationsOperationsCancel_579660;
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
  var path_579678 = newJObject()
  var query_579679 = newJObject()
  var body_579680 = newJObject()
  add(query_579679, "key", newJString(key))
  add(query_579679, "prettyPrint", newJBool(prettyPrint))
  add(query_579679, "oauth_token", newJString(oauthToken))
  add(query_579679, "$.xgafv", newJString(Xgafv))
  add(query_579679, "alt", newJString(alt))
  add(query_579679, "uploadType", newJString(uploadType))
  add(query_579679, "quotaUser", newJString(quotaUser))
  add(path_579678, "name", newJString(name))
  if body != nil:
    body_579680 = body
  add(query_579679, "callback", newJString(callback))
  add(query_579679, "fields", newJString(fields))
  add(query_579679, "access_token", newJString(accessToken))
  add(query_579679, "upload_protocol", newJString(uploadProtocol))
  result = call_579677.call(path_579678, query_579679, nil, nil, body_579680)

var containerProjectsLocationsOperationsCancel* = Call_ContainerProjectsLocationsOperationsCancel_579660(
    name: "containerProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ContainerProjectsLocationsOperationsCancel_579661,
    base: "/", url: url_ContainerProjectsLocationsOperationsCancel_579662,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCompleteIpRotation_579681 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersCompleteIpRotation_579683(
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

proc validate_ContainerProjectsLocationsClustersCompleteIpRotation_579682(
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
  var valid_579684 = path.getOrDefault("name")
  valid_579684 = validateParameter(valid_579684, JString, required = true,
                                 default = nil)
  if valid_579684 != nil:
    section.add "name", valid_579684
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
  var valid_579685 = query.getOrDefault("key")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = nil)
  if valid_579685 != nil:
    section.add "key", valid_579685
  var valid_579686 = query.getOrDefault("prettyPrint")
  valid_579686 = validateParameter(valid_579686, JBool, required = false,
                                 default = newJBool(true))
  if valid_579686 != nil:
    section.add "prettyPrint", valid_579686
  var valid_579687 = query.getOrDefault("oauth_token")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = nil)
  if valid_579687 != nil:
    section.add "oauth_token", valid_579687
  var valid_579688 = query.getOrDefault("$.xgafv")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = newJString("1"))
  if valid_579688 != nil:
    section.add "$.xgafv", valid_579688
  var valid_579689 = query.getOrDefault("alt")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = newJString("json"))
  if valid_579689 != nil:
    section.add "alt", valid_579689
  var valid_579690 = query.getOrDefault("uploadType")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "uploadType", valid_579690
  var valid_579691 = query.getOrDefault("quotaUser")
  valid_579691 = validateParameter(valid_579691, JString, required = false,
                                 default = nil)
  if valid_579691 != nil:
    section.add "quotaUser", valid_579691
  var valid_579692 = query.getOrDefault("callback")
  valid_579692 = validateParameter(valid_579692, JString, required = false,
                                 default = nil)
  if valid_579692 != nil:
    section.add "callback", valid_579692
  var valid_579693 = query.getOrDefault("fields")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = nil)
  if valid_579693 != nil:
    section.add "fields", valid_579693
  var valid_579694 = query.getOrDefault("access_token")
  valid_579694 = validateParameter(valid_579694, JString, required = false,
                                 default = nil)
  if valid_579694 != nil:
    section.add "access_token", valid_579694
  var valid_579695 = query.getOrDefault("upload_protocol")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "upload_protocol", valid_579695
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

proc call*(call_579697: Call_ContainerProjectsLocationsClustersCompleteIpRotation_579681;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_579697.validator(path, query, header, formData, body)
  let scheme = call_579697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579697.url(scheme.get, call_579697.host, call_579697.base,
                         call_579697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579697, url, valid)

proc call*(call_579698: Call_ContainerProjectsLocationsClustersCompleteIpRotation_579681;
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
  var path_579699 = newJObject()
  var query_579700 = newJObject()
  var body_579701 = newJObject()
  add(query_579700, "key", newJString(key))
  add(query_579700, "prettyPrint", newJBool(prettyPrint))
  add(query_579700, "oauth_token", newJString(oauthToken))
  add(query_579700, "$.xgafv", newJString(Xgafv))
  add(query_579700, "alt", newJString(alt))
  add(query_579700, "uploadType", newJString(uploadType))
  add(query_579700, "quotaUser", newJString(quotaUser))
  add(path_579699, "name", newJString(name))
  if body != nil:
    body_579701 = body
  add(query_579700, "callback", newJString(callback))
  add(query_579700, "fields", newJString(fields))
  add(query_579700, "access_token", newJString(accessToken))
  add(query_579700, "upload_protocol", newJString(uploadProtocol))
  result = call_579698.call(path_579699, query_579700, nil, nil, body_579701)

var containerProjectsLocationsClustersCompleteIpRotation* = Call_ContainerProjectsLocationsClustersCompleteIpRotation_579681(
    name: "containerProjectsLocationsClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:completeIpRotation",
    validator: validate_ContainerProjectsLocationsClustersCompleteIpRotation_579682,
    base: "/", url: url_ContainerProjectsLocationsClustersCompleteIpRotation_579683,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsRollback_579702 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsRollback_579704(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsRollback_579703(
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
  var valid_579705 = path.getOrDefault("name")
  valid_579705 = validateParameter(valid_579705, JString, required = true,
                                 default = nil)
  if valid_579705 != nil:
    section.add "name", valid_579705
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
  var valid_579706 = query.getOrDefault("key")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = nil)
  if valid_579706 != nil:
    section.add "key", valid_579706
  var valid_579707 = query.getOrDefault("prettyPrint")
  valid_579707 = validateParameter(valid_579707, JBool, required = false,
                                 default = newJBool(true))
  if valid_579707 != nil:
    section.add "prettyPrint", valid_579707
  var valid_579708 = query.getOrDefault("oauth_token")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = nil)
  if valid_579708 != nil:
    section.add "oauth_token", valid_579708
  var valid_579709 = query.getOrDefault("$.xgafv")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = newJString("1"))
  if valid_579709 != nil:
    section.add "$.xgafv", valid_579709
  var valid_579710 = query.getOrDefault("alt")
  valid_579710 = validateParameter(valid_579710, JString, required = false,
                                 default = newJString("json"))
  if valid_579710 != nil:
    section.add "alt", valid_579710
  var valid_579711 = query.getOrDefault("uploadType")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "uploadType", valid_579711
  var valid_579712 = query.getOrDefault("quotaUser")
  valid_579712 = validateParameter(valid_579712, JString, required = false,
                                 default = nil)
  if valid_579712 != nil:
    section.add "quotaUser", valid_579712
  var valid_579713 = query.getOrDefault("callback")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "callback", valid_579713
  var valid_579714 = query.getOrDefault("fields")
  valid_579714 = validateParameter(valid_579714, JString, required = false,
                                 default = nil)
  if valid_579714 != nil:
    section.add "fields", valid_579714
  var valid_579715 = query.getOrDefault("access_token")
  valid_579715 = validateParameter(valid_579715, JString, required = false,
                                 default = nil)
  if valid_579715 != nil:
    section.add "access_token", valid_579715
  var valid_579716 = query.getOrDefault("upload_protocol")
  valid_579716 = validateParameter(valid_579716, JString, required = false,
                                 default = nil)
  if valid_579716 != nil:
    section.add "upload_protocol", valid_579716
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

proc call*(call_579718: Call_ContainerProjectsLocationsClustersNodePoolsRollback_579702;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_579718.validator(path, query, header, formData, body)
  let scheme = call_579718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579718.url(scheme.get, call_579718.host, call_579718.base,
                         call_579718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579718, url, valid)

proc call*(call_579719: Call_ContainerProjectsLocationsClustersNodePoolsRollback_579702;
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
  var path_579720 = newJObject()
  var query_579721 = newJObject()
  var body_579722 = newJObject()
  add(query_579721, "key", newJString(key))
  add(query_579721, "prettyPrint", newJBool(prettyPrint))
  add(query_579721, "oauth_token", newJString(oauthToken))
  add(query_579721, "$.xgafv", newJString(Xgafv))
  add(query_579721, "alt", newJString(alt))
  add(query_579721, "uploadType", newJString(uploadType))
  add(query_579721, "quotaUser", newJString(quotaUser))
  add(path_579720, "name", newJString(name))
  if body != nil:
    body_579722 = body
  add(query_579721, "callback", newJString(callback))
  add(query_579721, "fields", newJString(fields))
  add(query_579721, "access_token", newJString(accessToken))
  add(query_579721, "upload_protocol", newJString(uploadProtocol))
  result = call_579719.call(path_579720, query_579721, nil, nil, body_579722)

var containerProjectsLocationsClustersNodePoolsRollback* = Call_ContainerProjectsLocationsClustersNodePoolsRollback_579702(
    name: "containerProjectsLocationsClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:rollback",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsRollback_579703,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsRollback_579704,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetAddons_579723 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetAddons_579725(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetAddons_579724(path: JsonNode;
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
  var valid_579726 = path.getOrDefault("name")
  valid_579726 = validateParameter(valid_579726, JString, required = true,
                                 default = nil)
  if valid_579726 != nil:
    section.add "name", valid_579726
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
  var valid_579727 = query.getOrDefault("key")
  valid_579727 = validateParameter(valid_579727, JString, required = false,
                                 default = nil)
  if valid_579727 != nil:
    section.add "key", valid_579727
  var valid_579728 = query.getOrDefault("prettyPrint")
  valid_579728 = validateParameter(valid_579728, JBool, required = false,
                                 default = newJBool(true))
  if valid_579728 != nil:
    section.add "prettyPrint", valid_579728
  var valid_579729 = query.getOrDefault("oauth_token")
  valid_579729 = validateParameter(valid_579729, JString, required = false,
                                 default = nil)
  if valid_579729 != nil:
    section.add "oauth_token", valid_579729
  var valid_579730 = query.getOrDefault("$.xgafv")
  valid_579730 = validateParameter(valid_579730, JString, required = false,
                                 default = newJString("1"))
  if valid_579730 != nil:
    section.add "$.xgafv", valid_579730
  var valid_579731 = query.getOrDefault("alt")
  valid_579731 = validateParameter(valid_579731, JString, required = false,
                                 default = newJString("json"))
  if valid_579731 != nil:
    section.add "alt", valid_579731
  var valid_579732 = query.getOrDefault("uploadType")
  valid_579732 = validateParameter(valid_579732, JString, required = false,
                                 default = nil)
  if valid_579732 != nil:
    section.add "uploadType", valid_579732
  var valid_579733 = query.getOrDefault("quotaUser")
  valid_579733 = validateParameter(valid_579733, JString, required = false,
                                 default = nil)
  if valid_579733 != nil:
    section.add "quotaUser", valid_579733
  var valid_579734 = query.getOrDefault("callback")
  valid_579734 = validateParameter(valid_579734, JString, required = false,
                                 default = nil)
  if valid_579734 != nil:
    section.add "callback", valid_579734
  var valid_579735 = query.getOrDefault("fields")
  valid_579735 = validateParameter(valid_579735, JString, required = false,
                                 default = nil)
  if valid_579735 != nil:
    section.add "fields", valid_579735
  var valid_579736 = query.getOrDefault("access_token")
  valid_579736 = validateParameter(valid_579736, JString, required = false,
                                 default = nil)
  if valid_579736 != nil:
    section.add "access_token", valid_579736
  var valid_579737 = query.getOrDefault("upload_protocol")
  valid_579737 = validateParameter(valid_579737, JString, required = false,
                                 default = nil)
  if valid_579737 != nil:
    section.add "upload_protocol", valid_579737
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

proc call*(call_579739: Call_ContainerProjectsLocationsClustersSetAddons_579723;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_579739.validator(path, query, header, formData, body)
  let scheme = call_579739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579739.url(scheme.get, call_579739.host, call_579739.base,
                         call_579739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579739, url, valid)

proc call*(call_579740: Call_ContainerProjectsLocationsClustersSetAddons_579723;
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
  var path_579741 = newJObject()
  var query_579742 = newJObject()
  var body_579743 = newJObject()
  add(query_579742, "key", newJString(key))
  add(query_579742, "prettyPrint", newJBool(prettyPrint))
  add(query_579742, "oauth_token", newJString(oauthToken))
  add(query_579742, "$.xgafv", newJString(Xgafv))
  add(query_579742, "alt", newJString(alt))
  add(query_579742, "uploadType", newJString(uploadType))
  add(query_579742, "quotaUser", newJString(quotaUser))
  add(path_579741, "name", newJString(name))
  if body != nil:
    body_579743 = body
  add(query_579742, "callback", newJString(callback))
  add(query_579742, "fields", newJString(fields))
  add(query_579742, "access_token", newJString(accessToken))
  add(query_579742, "upload_protocol", newJString(uploadProtocol))
  result = call_579740.call(path_579741, query_579742, nil, nil, body_579743)

var containerProjectsLocationsClustersSetAddons* = Call_ContainerProjectsLocationsClustersSetAddons_579723(
    name: "containerProjectsLocationsClustersSetAddons",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAddons",
    validator: validate_ContainerProjectsLocationsClustersSetAddons_579724,
    base: "/", url: url_ContainerProjectsLocationsClustersSetAddons_579725,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579744 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579746(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579745(
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
  var valid_579747 = path.getOrDefault("name")
  valid_579747 = validateParameter(valid_579747, JString, required = true,
                                 default = nil)
  if valid_579747 != nil:
    section.add "name", valid_579747
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
  var valid_579748 = query.getOrDefault("key")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = nil)
  if valid_579748 != nil:
    section.add "key", valid_579748
  var valid_579749 = query.getOrDefault("prettyPrint")
  valid_579749 = validateParameter(valid_579749, JBool, required = false,
                                 default = newJBool(true))
  if valid_579749 != nil:
    section.add "prettyPrint", valid_579749
  var valid_579750 = query.getOrDefault("oauth_token")
  valid_579750 = validateParameter(valid_579750, JString, required = false,
                                 default = nil)
  if valid_579750 != nil:
    section.add "oauth_token", valid_579750
  var valid_579751 = query.getOrDefault("$.xgafv")
  valid_579751 = validateParameter(valid_579751, JString, required = false,
                                 default = newJString("1"))
  if valid_579751 != nil:
    section.add "$.xgafv", valid_579751
  var valid_579752 = query.getOrDefault("alt")
  valid_579752 = validateParameter(valid_579752, JString, required = false,
                                 default = newJString("json"))
  if valid_579752 != nil:
    section.add "alt", valid_579752
  var valid_579753 = query.getOrDefault("uploadType")
  valid_579753 = validateParameter(valid_579753, JString, required = false,
                                 default = nil)
  if valid_579753 != nil:
    section.add "uploadType", valid_579753
  var valid_579754 = query.getOrDefault("quotaUser")
  valid_579754 = validateParameter(valid_579754, JString, required = false,
                                 default = nil)
  if valid_579754 != nil:
    section.add "quotaUser", valid_579754
  var valid_579755 = query.getOrDefault("callback")
  valid_579755 = validateParameter(valid_579755, JString, required = false,
                                 default = nil)
  if valid_579755 != nil:
    section.add "callback", valid_579755
  var valid_579756 = query.getOrDefault("fields")
  valid_579756 = validateParameter(valid_579756, JString, required = false,
                                 default = nil)
  if valid_579756 != nil:
    section.add "fields", valid_579756
  var valid_579757 = query.getOrDefault("access_token")
  valid_579757 = validateParameter(valid_579757, JString, required = false,
                                 default = nil)
  if valid_579757 != nil:
    section.add "access_token", valid_579757
  var valid_579758 = query.getOrDefault("upload_protocol")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "upload_protocol", valid_579758
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

proc call*(call_579760: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579744;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_579760.validator(path, query, header, formData, body)
  let scheme = call_579760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579760.url(scheme.get, call_579760.host, call_579760.base,
                         call_579760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579760, url, valid)

proc call*(call_579761: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579744;
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
  var path_579762 = newJObject()
  var query_579763 = newJObject()
  var body_579764 = newJObject()
  add(query_579763, "key", newJString(key))
  add(query_579763, "prettyPrint", newJBool(prettyPrint))
  add(query_579763, "oauth_token", newJString(oauthToken))
  add(query_579763, "$.xgafv", newJString(Xgafv))
  add(query_579763, "alt", newJString(alt))
  add(query_579763, "uploadType", newJString(uploadType))
  add(query_579763, "quotaUser", newJString(quotaUser))
  add(path_579762, "name", newJString(name))
  if body != nil:
    body_579764 = body
  add(query_579763, "callback", newJString(callback))
  add(query_579763, "fields", newJString(fields))
  add(query_579763, "access_token", newJString(accessToken))
  add(query_579763, "upload_protocol", newJString(uploadProtocol))
  result = call_579761.call(path_579762, query_579763, nil, nil, body_579764)

var containerProjectsLocationsClustersNodePoolsSetAutoscaling* = Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579744(
    name: "containerProjectsLocationsClustersNodePoolsSetAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAutoscaling", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579745,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579746,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLegacyAbac_579765 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetLegacyAbac_579767(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetLegacyAbac_579766(
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
  var valid_579768 = path.getOrDefault("name")
  valid_579768 = validateParameter(valid_579768, JString, required = true,
                                 default = nil)
  if valid_579768 != nil:
    section.add "name", valid_579768
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
  var valid_579769 = query.getOrDefault("key")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "key", valid_579769
  var valid_579770 = query.getOrDefault("prettyPrint")
  valid_579770 = validateParameter(valid_579770, JBool, required = false,
                                 default = newJBool(true))
  if valid_579770 != nil:
    section.add "prettyPrint", valid_579770
  var valid_579771 = query.getOrDefault("oauth_token")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "oauth_token", valid_579771
  var valid_579772 = query.getOrDefault("$.xgafv")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = newJString("1"))
  if valid_579772 != nil:
    section.add "$.xgafv", valid_579772
  var valid_579773 = query.getOrDefault("alt")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = newJString("json"))
  if valid_579773 != nil:
    section.add "alt", valid_579773
  var valid_579774 = query.getOrDefault("uploadType")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "uploadType", valid_579774
  var valid_579775 = query.getOrDefault("quotaUser")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "quotaUser", valid_579775
  var valid_579776 = query.getOrDefault("callback")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "callback", valid_579776
  var valid_579777 = query.getOrDefault("fields")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "fields", valid_579777
  var valid_579778 = query.getOrDefault("access_token")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "access_token", valid_579778
  var valid_579779 = query.getOrDefault("upload_protocol")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "upload_protocol", valid_579779
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

proc call*(call_579781: Call_ContainerProjectsLocationsClustersSetLegacyAbac_579765;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_579781.validator(path, query, header, formData, body)
  let scheme = call_579781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579781.url(scheme.get, call_579781.host, call_579781.base,
                         call_579781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579781, url, valid)

proc call*(call_579782: Call_ContainerProjectsLocationsClustersSetLegacyAbac_579765;
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
  var path_579783 = newJObject()
  var query_579784 = newJObject()
  var body_579785 = newJObject()
  add(query_579784, "key", newJString(key))
  add(query_579784, "prettyPrint", newJBool(prettyPrint))
  add(query_579784, "oauth_token", newJString(oauthToken))
  add(query_579784, "$.xgafv", newJString(Xgafv))
  add(query_579784, "alt", newJString(alt))
  add(query_579784, "uploadType", newJString(uploadType))
  add(query_579784, "quotaUser", newJString(quotaUser))
  add(path_579783, "name", newJString(name))
  if body != nil:
    body_579785 = body
  add(query_579784, "callback", newJString(callback))
  add(query_579784, "fields", newJString(fields))
  add(query_579784, "access_token", newJString(accessToken))
  add(query_579784, "upload_protocol", newJString(uploadProtocol))
  result = call_579782.call(path_579783, query_579784, nil, nil, body_579785)

var containerProjectsLocationsClustersSetLegacyAbac* = Call_ContainerProjectsLocationsClustersSetLegacyAbac_579765(
    name: "containerProjectsLocationsClustersSetLegacyAbac",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLegacyAbac",
    validator: validate_ContainerProjectsLocationsClustersSetLegacyAbac_579766,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLegacyAbac_579767,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLocations_579786 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetLocations_579788(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetLocations_579787(
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
  var valid_579789 = path.getOrDefault("name")
  valid_579789 = validateParameter(valid_579789, JString, required = true,
                                 default = nil)
  if valid_579789 != nil:
    section.add "name", valid_579789
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
  var valid_579790 = query.getOrDefault("key")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "key", valid_579790
  var valid_579791 = query.getOrDefault("prettyPrint")
  valid_579791 = validateParameter(valid_579791, JBool, required = false,
                                 default = newJBool(true))
  if valid_579791 != nil:
    section.add "prettyPrint", valid_579791
  var valid_579792 = query.getOrDefault("oauth_token")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "oauth_token", valid_579792
  var valid_579793 = query.getOrDefault("$.xgafv")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = newJString("1"))
  if valid_579793 != nil:
    section.add "$.xgafv", valid_579793
  var valid_579794 = query.getOrDefault("alt")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = newJString("json"))
  if valid_579794 != nil:
    section.add "alt", valid_579794
  var valid_579795 = query.getOrDefault("uploadType")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "uploadType", valid_579795
  var valid_579796 = query.getOrDefault("quotaUser")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "quotaUser", valid_579796
  var valid_579797 = query.getOrDefault("callback")
  valid_579797 = validateParameter(valid_579797, JString, required = false,
                                 default = nil)
  if valid_579797 != nil:
    section.add "callback", valid_579797
  var valid_579798 = query.getOrDefault("fields")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "fields", valid_579798
  var valid_579799 = query.getOrDefault("access_token")
  valid_579799 = validateParameter(valid_579799, JString, required = false,
                                 default = nil)
  if valid_579799 != nil:
    section.add "access_token", valid_579799
  var valid_579800 = query.getOrDefault("upload_protocol")
  valid_579800 = validateParameter(valid_579800, JString, required = false,
                                 default = nil)
  if valid_579800 != nil:
    section.add "upload_protocol", valid_579800
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

proc call*(call_579802: Call_ContainerProjectsLocationsClustersSetLocations_579786;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_579802.validator(path, query, header, formData, body)
  let scheme = call_579802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579802.url(scheme.get, call_579802.host, call_579802.base,
                         call_579802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579802, url, valid)

proc call*(call_579803: Call_ContainerProjectsLocationsClustersSetLocations_579786;
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
  var path_579804 = newJObject()
  var query_579805 = newJObject()
  var body_579806 = newJObject()
  add(query_579805, "key", newJString(key))
  add(query_579805, "prettyPrint", newJBool(prettyPrint))
  add(query_579805, "oauth_token", newJString(oauthToken))
  add(query_579805, "$.xgafv", newJString(Xgafv))
  add(query_579805, "alt", newJString(alt))
  add(query_579805, "uploadType", newJString(uploadType))
  add(query_579805, "quotaUser", newJString(quotaUser))
  add(path_579804, "name", newJString(name))
  if body != nil:
    body_579806 = body
  add(query_579805, "callback", newJString(callback))
  add(query_579805, "fields", newJString(fields))
  add(query_579805, "access_token", newJString(accessToken))
  add(query_579805, "upload_protocol", newJString(uploadProtocol))
  result = call_579803.call(path_579804, query_579805, nil, nil, body_579806)

var containerProjectsLocationsClustersSetLocations* = Call_ContainerProjectsLocationsClustersSetLocations_579786(
    name: "containerProjectsLocationsClustersSetLocations",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLocations",
    validator: validate_ContainerProjectsLocationsClustersSetLocations_579787,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLocations_579788,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLogging_579807 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetLogging_579809(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetLogging_579808(path: JsonNode;
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
  var valid_579810 = path.getOrDefault("name")
  valid_579810 = validateParameter(valid_579810, JString, required = true,
                                 default = nil)
  if valid_579810 != nil:
    section.add "name", valid_579810
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
  var valid_579811 = query.getOrDefault("key")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "key", valid_579811
  var valid_579812 = query.getOrDefault("prettyPrint")
  valid_579812 = validateParameter(valid_579812, JBool, required = false,
                                 default = newJBool(true))
  if valid_579812 != nil:
    section.add "prettyPrint", valid_579812
  var valid_579813 = query.getOrDefault("oauth_token")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "oauth_token", valid_579813
  var valid_579814 = query.getOrDefault("$.xgafv")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = newJString("1"))
  if valid_579814 != nil:
    section.add "$.xgafv", valid_579814
  var valid_579815 = query.getOrDefault("alt")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = newJString("json"))
  if valid_579815 != nil:
    section.add "alt", valid_579815
  var valid_579816 = query.getOrDefault("uploadType")
  valid_579816 = validateParameter(valid_579816, JString, required = false,
                                 default = nil)
  if valid_579816 != nil:
    section.add "uploadType", valid_579816
  var valid_579817 = query.getOrDefault("quotaUser")
  valid_579817 = validateParameter(valid_579817, JString, required = false,
                                 default = nil)
  if valid_579817 != nil:
    section.add "quotaUser", valid_579817
  var valid_579818 = query.getOrDefault("callback")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = nil)
  if valid_579818 != nil:
    section.add "callback", valid_579818
  var valid_579819 = query.getOrDefault("fields")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "fields", valid_579819
  var valid_579820 = query.getOrDefault("access_token")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "access_token", valid_579820
  var valid_579821 = query.getOrDefault("upload_protocol")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "upload_protocol", valid_579821
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

proc call*(call_579823: Call_ContainerProjectsLocationsClustersSetLogging_579807;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_579823.validator(path, query, header, formData, body)
  let scheme = call_579823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579823.url(scheme.get, call_579823.host, call_579823.base,
                         call_579823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579823, url, valid)

proc call*(call_579824: Call_ContainerProjectsLocationsClustersSetLogging_579807;
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
  var path_579825 = newJObject()
  var query_579826 = newJObject()
  var body_579827 = newJObject()
  add(query_579826, "key", newJString(key))
  add(query_579826, "prettyPrint", newJBool(prettyPrint))
  add(query_579826, "oauth_token", newJString(oauthToken))
  add(query_579826, "$.xgafv", newJString(Xgafv))
  add(query_579826, "alt", newJString(alt))
  add(query_579826, "uploadType", newJString(uploadType))
  add(query_579826, "quotaUser", newJString(quotaUser))
  add(path_579825, "name", newJString(name))
  if body != nil:
    body_579827 = body
  add(query_579826, "callback", newJString(callback))
  add(query_579826, "fields", newJString(fields))
  add(query_579826, "access_token", newJString(accessToken))
  add(query_579826, "upload_protocol", newJString(uploadProtocol))
  result = call_579824.call(path_579825, query_579826, nil, nil, body_579827)

var containerProjectsLocationsClustersSetLogging* = Call_ContainerProjectsLocationsClustersSetLogging_579807(
    name: "containerProjectsLocationsClustersSetLogging",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLogging",
    validator: validate_ContainerProjectsLocationsClustersSetLogging_579808,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLogging_579809,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_579828 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetMaintenancePolicy_579830(
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

proc validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_579829(
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
  var valid_579831 = path.getOrDefault("name")
  valid_579831 = validateParameter(valid_579831, JString, required = true,
                                 default = nil)
  if valid_579831 != nil:
    section.add "name", valid_579831
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
  var valid_579832 = query.getOrDefault("key")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "key", valid_579832
  var valid_579833 = query.getOrDefault("prettyPrint")
  valid_579833 = validateParameter(valid_579833, JBool, required = false,
                                 default = newJBool(true))
  if valid_579833 != nil:
    section.add "prettyPrint", valid_579833
  var valid_579834 = query.getOrDefault("oauth_token")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "oauth_token", valid_579834
  var valid_579835 = query.getOrDefault("$.xgafv")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("1"))
  if valid_579835 != nil:
    section.add "$.xgafv", valid_579835
  var valid_579836 = query.getOrDefault("alt")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = newJString("json"))
  if valid_579836 != nil:
    section.add "alt", valid_579836
  var valid_579837 = query.getOrDefault("uploadType")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "uploadType", valid_579837
  var valid_579838 = query.getOrDefault("quotaUser")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "quotaUser", valid_579838
  var valid_579839 = query.getOrDefault("callback")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "callback", valid_579839
  var valid_579840 = query.getOrDefault("fields")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "fields", valid_579840
  var valid_579841 = query.getOrDefault("access_token")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "access_token", valid_579841
  var valid_579842 = query.getOrDefault("upload_protocol")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "upload_protocol", valid_579842
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

proc call*(call_579844: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_579828;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_579844.validator(path, query, header, formData, body)
  let scheme = call_579844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579844.url(scheme.get, call_579844.host, call_579844.base,
                         call_579844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579844, url, valid)

proc call*(call_579845: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_579828;
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
  var path_579846 = newJObject()
  var query_579847 = newJObject()
  var body_579848 = newJObject()
  add(query_579847, "key", newJString(key))
  add(query_579847, "prettyPrint", newJBool(prettyPrint))
  add(query_579847, "oauth_token", newJString(oauthToken))
  add(query_579847, "$.xgafv", newJString(Xgafv))
  add(query_579847, "alt", newJString(alt))
  add(query_579847, "uploadType", newJString(uploadType))
  add(query_579847, "quotaUser", newJString(quotaUser))
  add(path_579846, "name", newJString(name))
  if body != nil:
    body_579848 = body
  add(query_579847, "callback", newJString(callback))
  add(query_579847, "fields", newJString(fields))
  add(query_579847, "access_token", newJString(accessToken))
  add(query_579847, "upload_protocol", newJString(uploadProtocol))
  result = call_579845.call(path_579846, query_579847, nil, nil, body_579848)

var containerProjectsLocationsClustersSetMaintenancePolicy* = Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_579828(
    name: "containerProjectsLocationsClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMaintenancePolicy",
    validator: validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_579829,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMaintenancePolicy_579830,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_579849 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsSetManagement_579851(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_579850(
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
  var valid_579852 = path.getOrDefault("name")
  valid_579852 = validateParameter(valid_579852, JString, required = true,
                                 default = nil)
  if valid_579852 != nil:
    section.add "name", valid_579852
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
  var valid_579853 = query.getOrDefault("key")
  valid_579853 = validateParameter(valid_579853, JString, required = false,
                                 default = nil)
  if valid_579853 != nil:
    section.add "key", valid_579853
  var valid_579854 = query.getOrDefault("prettyPrint")
  valid_579854 = validateParameter(valid_579854, JBool, required = false,
                                 default = newJBool(true))
  if valid_579854 != nil:
    section.add "prettyPrint", valid_579854
  var valid_579855 = query.getOrDefault("oauth_token")
  valid_579855 = validateParameter(valid_579855, JString, required = false,
                                 default = nil)
  if valid_579855 != nil:
    section.add "oauth_token", valid_579855
  var valid_579856 = query.getOrDefault("$.xgafv")
  valid_579856 = validateParameter(valid_579856, JString, required = false,
                                 default = newJString("1"))
  if valid_579856 != nil:
    section.add "$.xgafv", valid_579856
  var valid_579857 = query.getOrDefault("alt")
  valid_579857 = validateParameter(valid_579857, JString, required = false,
                                 default = newJString("json"))
  if valid_579857 != nil:
    section.add "alt", valid_579857
  var valid_579858 = query.getOrDefault("uploadType")
  valid_579858 = validateParameter(valid_579858, JString, required = false,
                                 default = nil)
  if valid_579858 != nil:
    section.add "uploadType", valid_579858
  var valid_579859 = query.getOrDefault("quotaUser")
  valid_579859 = validateParameter(valid_579859, JString, required = false,
                                 default = nil)
  if valid_579859 != nil:
    section.add "quotaUser", valid_579859
  var valid_579860 = query.getOrDefault("callback")
  valid_579860 = validateParameter(valid_579860, JString, required = false,
                                 default = nil)
  if valid_579860 != nil:
    section.add "callback", valid_579860
  var valid_579861 = query.getOrDefault("fields")
  valid_579861 = validateParameter(valid_579861, JString, required = false,
                                 default = nil)
  if valid_579861 != nil:
    section.add "fields", valid_579861
  var valid_579862 = query.getOrDefault("access_token")
  valid_579862 = validateParameter(valid_579862, JString, required = false,
                                 default = nil)
  if valid_579862 != nil:
    section.add "access_token", valid_579862
  var valid_579863 = query.getOrDefault("upload_protocol")
  valid_579863 = validateParameter(valid_579863, JString, required = false,
                                 default = nil)
  if valid_579863 != nil:
    section.add "upload_protocol", valid_579863
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

proc call*(call_579865: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_579849;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579866: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_579849;
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
  var path_579867 = newJObject()
  var query_579868 = newJObject()
  var body_579869 = newJObject()
  add(query_579868, "key", newJString(key))
  add(query_579868, "prettyPrint", newJBool(prettyPrint))
  add(query_579868, "oauth_token", newJString(oauthToken))
  add(query_579868, "$.xgafv", newJString(Xgafv))
  add(query_579868, "alt", newJString(alt))
  add(query_579868, "uploadType", newJString(uploadType))
  add(query_579868, "quotaUser", newJString(quotaUser))
  add(path_579867, "name", newJString(name))
  if body != nil:
    body_579869 = body
  add(query_579868, "callback", newJString(callback))
  add(query_579868, "fields", newJString(fields))
  add(query_579868, "access_token", newJString(accessToken))
  add(query_579868, "upload_protocol", newJString(uploadProtocol))
  result = call_579866.call(path_579867, query_579868, nil, nil, body_579869)

var containerProjectsLocationsClustersNodePoolsSetManagement* = Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_579849(
    name: "containerProjectsLocationsClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setManagement", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_579850,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetManagement_579851,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMasterAuth_579870 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetMasterAuth_579872(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetMasterAuth_579871(
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
  var valid_579873 = path.getOrDefault("name")
  valid_579873 = validateParameter(valid_579873, JString, required = true,
                                 default = nil)
  if valid_579873 != nil:
    section.add "name", valid_579873
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
  var valid_579874 = query.getOrDefault("key")
  valid_579874 = validateParameter(valid_579874, JString, required = false,
                                 default = nil)
  if valid_579874 != nil:
    section.add "key", valid_579874
  var valid_579875 = query.getOrDefault("prettyPrint")
  valid_579875 = validateParameter(valid_579875, JBool, required = false,
                                 default = newJBool(true))
  if valid_579875 != nil:
    section.add "prettyPrint", valid_579875
  var valid_579876 = query.getOrDefault("oauth_token")
  valid_579876 = validateParameter(valid_579876, JString, required = false,
                                 default = nil)
  if valid_579876 != nil:
    section.add "oauth_token", valid_579876
  var valid_579877 = query.getOrDefault("$.xgafv")
  valid_579877 = validateParameter(valid_579877, JString, required = false,
                                 default = newJString("1"))
  if valid_579877 != nil:
    section.add "$.xgafv", valid_579877
  var valid_579878 = query.getOrDefault("alt")
  valid_579878 = validateParameter(valid_579878, JString, required = false,
                                 default = newJString("json"))
  if valid_579878 != nil:
    section.add "alt", valid_579878
  var valid_579879 = query.getOrDefault("uploadType")
  valid_579879 = validateParameter(valid_579879, JString, required = false,
                                 default = nil)
  if valid_579879 != nil:
    section.add "uploadType", valid_579879
  var valid_579880 = query.getOrDefault("quotaUser")
  valid_579880 = validateParameter(valid_579880, JString, required = false,
                                 default = nil)
  if valid_579880 != nil:
    section.add "quotaUser", valid_579880
  var valid_579881 = query.getOrDefault("callback")
  valid_579881 = validateParameter(valid_579881, JString, required = false,
                                 default = nil)
  if valid_579881 != nil:
    section.add "callback", valid_579881
  var valid_579882 = query.getOrDefault("fields")
  valid_579882 = validateParameter(valid_579882, JString, required = false,
                                 default = nil)
  if valid_579882 != nil:
    section.add "fields", valid_579882
  var valid_579883 = query.getOrDefault("access_token")
  valid_579883 = validateParameter(valid_579883, JString, required = false,
                                 default = nil)
  if valid_579883 != nil:
    section.add "access_token", valid_579883
  var valid_579884 = query.getOrDefault("upload_protocol")
  valid_579884 = validateParameter(valid_579884, JString, required = false,
                                 default = nil)
  if valid_579884 != nil:
    section.add "upload_protocol", valid_579884
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

proc call*(call_579886: Call_ContainerProjectsLocationsClustersSetMasterAuth_579870;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_579886.validator(path, query, header, formData, body)
  let scheme = call_579886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579886.url(scheme.get, call_579886.host, call_579886.base,
                         call_579886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579886, url, valid)

proc call*(call_579887: Call_ContainerProjectsLocationsClustersSetMasterAuth_579870;
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
  var path_579888 = newJObject()
  var query_579889 = newJObject()
  var body_579890 = newJObject()
  add(query_579889, "key", newJString(key))
  add(query_579889, "prettyPrint", newJBool(prettyPrint))
  add(query_579889, "oauth_token", newJString(oauthToken))
  add(query_579889, "$.xgafv", newJString(Xgafv))
  add(query_579889, "alt", newJString(alt))
  add(query_579889, "uploadType", newJString(uploadType))
  add(query_579889, "quotaUser", newJString(quotaUser))
  add(path_579888, "name", newJString(name))
  if body != nil:
    body_579890 = body
  add(query_579889, "callback", newJString(callback))
  add(query_579889, "fields", newJString(fields))
  add(query_579889, "access_token", newJString(accessToken))
  add(query_579889, "upload_protocol", newJString(uploadProtocol))
  result = call_579887.call(path_579888, query_579889, nil, nil, body_579890)

var containerProjectsLocationsClustersSetMasterAuth* = Call_ContainerProjectsLocationsClustersSetMasterAuth_579870(
    name: "containerProjectsLocationsClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMasterAuth",
    validator: validate_ContainerProjectsLocationsClustersSetMasterAuth_579871,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMasterAuth_579872,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMonitoring_579891 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetMonitoring_579893(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetMonitoring_579892(
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
  var valid_579894 = path.getOrDefault("name")
  valid_579894 = validateParameter(valid_579894, JString, required = true,
                                 default = nil)
  if valid_579894 != nil:
    section.add "name", valid_579894
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
  var valid_579895 = query.getOrDefault("key")
  valid_579895 = validateParameter(valid_579895, JString, required = false,
                                 default = nil)
  if valid_579895 != nil:
    section.add "key", valid_579895
  var valid_579896 = query.getOrDefault("prettyPrint")
  valid_579896 = validateParameter(valid_579896, JBool, required = false,
                                 default = newJBool(true))
  if valid_579896 != nil:
    section.add "prettyPrint", valid_579896
  var valid_579897 = query.getOrDefault("oauth_token")
  valid_579897 = validateParameter(valid_579897, JString, required = false,
                                 default = nil)
  if valid_579897 != nil:
    section.add "oauth_token", valid_579897
  var valid_579898 = query.getOrDefault("$.xgafv")
  valid_579898 = validateParameter(valid_579898, JString, required = false,
                                 default = newJString("1"))
  if valid_579898 != nil:
    section.add "$.xgafv", valid_579898
  var valid_579899 = query.getOrDefault("alt")
  valid_579899 = validateParameter(valid_579899, JString, required = false,
                                 default = newJString("json"))
  if valid_579899 != nil:
    section.add "alt", valid_579899
  var valid_579900 = query.getOrDefault("uploadType")
  valid_579900 = validateParameter(valid_579900, JString, required = false,
                                 default = nil)
  if valid_579900 != nil:
    section.add "uploadType", valid_579900
  var valid_579901 = query.getOrDefault("quotaUser")
  valid_579901 = validateParameter(valid_579901, JString, required = false,
                                 default = nil)
  if valid_579901 != nil:
    section.add "quotaUser", valid_579901
  var valid_579902 = query.getOrDefault("callback")
  valid_579902 = validateParameter(valid_579902, JString, required = false,
                                 default = nil)
  if valid_579902 != nil:
    section.add "callback", valid_579902
  var valid_579903 = query.getOrDefault("fields")
  valid_579903 = validateParameter(valid_579903, JString, required = false,
                                 default = nil)
  if valid_579903 != nil:
    section.add "fields", valid_579903
  var valid_579904 = query.getOrDefault("access_token")
  valid_579904 = validateParameter(valid_579904, JString, required = false,
                                 default = nil)
  if valid_579904 != nil:
    section.add "access_token", valid_579904
  var valid_579905 = query.getOrDefault("upload_protocol")
  valid_579905 = validateParameter(valid_579905, JString, required = false,
                                 default = nil)
  if valid_579905 != nil:
    section.add "upload_protocol", valid_579905
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

proc call*(call_579907: Call_ContainerProjectsLocationsClustersSetMonitoring_579891;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_579907.validator(path, query, header, formData, body)
  let scheme = call_579907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579907.url(scheme.get, call_579907.host, call_579907.base,
                         call_579907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579907, url, valid)

proc call*(call_579908: Call_ContainerProjectsLocationsClustersSetMonitoring_579891;
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
  var path_579909 = newJObject()
  var query_579910 = newJObject()
  var body_579911 = newJObject()
  add(query_579910, "key", newJString(key))
  add(query_579910, "prettyPrint", newJBool(prettyPrint))
  add(query_579910, "oauth_token", newJString(oauthToken))
  add(query_579910, "$.xgafv", newJString(Xgafv))
  add(query_579910, "alt", newJString(alt))
  add(query_579910, "uploadType", newJString(uploadType))
  add(query_579910, "quotaUser", newJString(quotaUser))
  add(path_579909, "name", newJString(name))
  if body != nil:
    body_579911 = body
  add(query_579910, "callback", newJString(callback))
  add(query_579910, "fields", newJString(fields))
  add(query_579910, "access_token", newJString(accessToken))
  add(query_579910, "upload_protocol", newJString(uploadProtocol))
  result = call_579908.call(path_579909, query_579910, nil, nil, body_579911)

var containerProjectsLocationsClustersSetMonitoring* = Call_ContainerProjectsLocationsClustersSetMonitoring_579891(
    name: "containerProjectsLocationsClustersSetMonitoring",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMonitoring",
    validator: validate_ContainerProjectsLocationsClustersSetMonitoring_579892,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMonitoring_579893,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetNetworkPolicy_579912 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetNetworkPolicy_579914(
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

proc validate_ContainerProjectsLocationsClustersSetNetworkPolicy_579913(
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
  var valid_579915 = path.getOrDefault("name")
  valid_579915 = validateParameter(valid_579915, JString, required = true,
                                 default = nil)
  if valid_579915 != nil:
    section.add "name", valid_579915
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
  var valid_579916 = query.getOrDefault("key")
  valid_579916 = validateParameter(valid_579916, JString, required = false,
                                 default = nil)
  if valid_579916 != nil:
    section.add "key", valid_579916
  var valid_579917 = query.getOrDefault("prettyPrint")
  valid_579917 = validateParameter(valid_579917, JBool, required = false,
                                 default = newJBool(true))
  if valid_579917 != nil:
    section.add "prettyPrint", valid_579917
  var valid_579918 = query.getOrDefault("oauth_token")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "oauth_token", valid_579918
  var valid_579919 = query.getOrDefault("$.xgafv")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = newJString("1"))
  if valid_579919 != nil:
    section.add "$.xgafv", valid_579919
  var valid_579920 = query.getOrDefault("alt")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = newJString("json"))
  if valid_579920 != nil:
    section.add "alt", valid_579920
  var valid_579921 = query.getOrDefault("uploadType")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "uploadType", valid_579921
  var valid_579922 = query.getOrDefault("quotaUser")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "quotaUser", valid_579922
  var valid_579923 = query.getOrDefault("callback")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "callback", valid_579923
  var valid_579924 = query.getOrDefault("fields")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "fields", valid_579924
  var valid_579925 = query.getOrDefault("access_token")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = nil)
  if valid_579925 != nil:
    section.add "access_token", valid_579925
  var valid_579926 = query.getOrDefault("upload_protocol")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "upload_protocol", valid_579926
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

proc call*(call_579928: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_579912;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_579928.validator(path, query, header, formData, body)
  let scheme = call_579928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579928.url(scheme.get, call_579928.host, call_579928.base,
                         call_579928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579928, url, valid)

proc call*(call_579929: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_579912;
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
  var path_579930 = newJObject()
  var query_579931 = newJObject()
  var body_579932 = newJObject()
  add(query_579931, "key", newJString(key))
  add(query_579931, "prettyPrint", newJBool(prettyPrint))
  add(query_579931, "oauth_token", newJString(oauthToken))
  add(query_579931, "$.xgafv", newJString(Xgafv))
  add(query_579931, "alt", newJString(alt))
  add(query_579931, "uploadType", newJString(uploadType))
  add(query_579931, "quotaUser", newJString(quotaUser))
  add(path_579930, "name", newJString(name))
  if body != nil:
    body_579932 = body
  add(query_579931, "callback", newJString(callback))
  add(query_579931, "fields", newJString(fields))
  add(query_579931, "access_token", newJString(accessToken))
  add(query_579931, "upload_protocol", newJString(uploadProtocol))
  result = call_579929.call(path_579930, query_579931, nil, nil, body_579932)

var containerProjectsLocationsClustersSetNetworkPolicy* = Call_ContainerProjectsLocationsClustersSetNetworkPolicy_579912(
    name: "containerProjectsLocationsClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setNetworkPolicy",
    validator: validate_ContainerProjectsLocationsClustersSetNetworkPolicy_579913,
    base: "/", url: url_ContainerProjectsLocationsClustersSetNetworkPolicy_579914,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetResourceLabels_579933 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetResourceLabels_579935(
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

proc validate_ContainerProjectsLocationsClustersSetResourceLabels_579934(
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
  var valid_579936 = path.getOrDefault("name")
  valid_579936 = validateParameter(valid_579936, JString, required = true,
                                 default = nil)
  if valid_579936 != nil:
    section.add "name", valid_579936
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
  var valid_579937 = query.getOrDefault("key")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "key", valid_579937
  var valid_579938 = query.getOrDefault("prettyPrint")
  valid_579938 = validateParameter(valid_579938, JBool, required = false,
                                 default = newJBool(true))
  if valid_579938 != nil:
    section.add "prettyPrint", valid_579938
  var valid_579939 = query.getOrDefault("oauth_token")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "oauth_token", valid_579939
  var valid_579940 = query.getOrDefault("$.xgafv")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = newJString("1"))
  if valid_579940 != nil:
    section.add "$.xgafv", valid_579940
  var valid_579941 = query.getOrDefault("alt")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = newJString("json"))
  if valid_579941 != nil:
    section.add "alt", valid_579941
  var valid_579942 = query.getOrDefault("uploadType")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "uploadType", valid_579942
  var valid_579943 = query.getOrDefault("quotaUser")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "quotaUser", valid_579943
  var valid_579944 = query.getOrDefault("callback")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "callback", valid_579944
  var valid_579945 = query.getOrDefault("fields")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "fields", valid_579945
  var valid_579946 = query.getOrDefault("access_token")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "access_token", valid_579946
  var valid_579947 = query.getOrDefault("upload_protocol")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "upload_protocol", valid_579947
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

proc call*(call_579949: Call_ContainerProjectsLocationsClustersSetResourceLabels_579933;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_579949.validator(path, query, header, formData, body)
  let scheme = call_579949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579949.url(scheme.get, call_579949.host, call_579949.base,
                         call_579949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579949, url, valid)

proc call*(call_579950: Call_ContainerProjectsLocationsClustersSetResourceLabels_579933;
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
  var path_579951 = newJObject()
  var query_579952 = newJObject()
  var body_579953 = newJObject()
  add(query_579952, "key", newJString(key))
  add(query_579952, "prettyPrint", newJBool(prettyPrint))
  add(query_579952, "oauth_token", newJString(oauthToken))
  add(query_579952, "$.xgafv", newJString(Xgafv))
  add(query_579952, "alt", newJString(alt))
  add(query_579952, "uploadType", newJString(uploadType))
  add(query_579952, "quotaUser", newJString(quotaUser))
  add(path_579951, "name", newJString(name))
  if body != nil:
    body_579953 = body
  add(query_579952, "callback", newJString(callback))
  add(query_579952, "fields", newJString(fields))
  add(query_579952, "access_token", newJString(accessToken))
  add(query_579952, "upload_protocol", newJString(uploadProtocol))
  result = call_579950.call(path_579951, query_579952, nil, nil, body_579953)

var containerProjectsLocationsClustersSetResourceLabels* = Call_ContainerProjectsLocationsClustersSetResourceLabels_579933(
    name: "containerProjectsLocationsClustersSetResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setResourceLabels",
    validator: validate_ContainerProjectsLocationsClustersSetResourceLabels_579934,
    base: "/", url: url_ContainerProjectsLocationsClustersSetResourceLabels_579935,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetSize_579954 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsSetSize_579956(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetSize_579955(
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
  var valid_579957 = path.getOrDefault("name")
  valid_579957 = validateParameter(valid_579957, JString, required = true,
                                 default = nil)
  if valid_579957 != nil:
    section.add "name", valid_579957
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
  var valid_579958 = query.getOrDefault("key")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "key", valid_579958
  var valid_579959 = query.getOrDefault("prettyPrint")
  valid_579959 = validateParameter(valid_579959, JBool, required = false,
                                 default = newJBool(true))
  if valid_579959 != nil:
    section.add "prettyPrint", valid_579959
  var valid_579960 = query.getOrDefault("oauth_token")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "oauth_token", valid_579960
  var valid_579961 = query.getOrDefault("$.xgafv")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = newJString("1"))
  if valid_579961 != nil:
    section.add "$.xgafv", valid_579961
  var valid_579962 = query.getOrDefault("alt")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = newJString("json"))
  if valid_579962 != nil:
    section.add "alt", valid_579962
  var valid_579963 = query.getOrDefault("uploadType")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "uploadType", valid_579963
  var valid_579964 = query.getOrDefault("quotaUser")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "quotaUser", valid_579964
  var valid_579965 = query.getOrDefault("callback")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "callback", valid_579965
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
  var valid_579967 = query.getOrDefault("access_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "access_token", valid_579967
  var valid_579968 = query.getOrDefault("upload_protocol")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "upload_protocol", valid_579968
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

proc call*(call_579970: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_579954;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_579970.validator(path, query, header, formData, body)
  let scheme = call_579970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579970.url(scheme.get, call_579970.host, call_579970.base,
                         call_579970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579970, url, valid)

proc call*(call_579971: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_579954;
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
  var path_579972 = newJObject()
  var query_579973 = newJObject()
  var body_579974 = newJObject()
  add(query_579973, "key", newJString(key))
  add(query_579973, "prettyPrint", newJBool(prettyPrint))
  add(query_579973, "oauth_token", newJString(oauthToken))
  add(query_579973, "$.xgafv", newJString(Xgafv))
  add(query_579973, "alt", newJString(alt))
  add(query_579973, "uploadType", newJString(uploadType))
  add(query_579973, "quotaUser", newJString(quotaUser))
  add(path_579972, "name", newJString(name))
  if body != nil:
    body_579974 = body
  add(query_579973, "callback", newJString(callback))
  add(query_579973, "fields", newJString(fields))
  add(query_579973, "access_token", newJString(accessToken))
  add(query_579973, "upload_protocol", newJString(uploadProtocol))
  result = call_579971.call(path_579972, query_579973, nil, nil, body_579974)

var containerProjectsLocationsClustersNodePoolsSetSize* = Call_ContainerProjectsLocationsClustersNodePoolsSetSize_579954(
    name: "containerProjectsLocationsClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setSize",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsSetSize_579955,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetSize_579956,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersStartIpRotation_579975 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersStartIpRotation_579977(
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

proc validate_ContainerProjectsLocationsClustersStartIpRotation_579976(
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
  var valid_579978 = path.getOrDefault("name")
  valid_579978 = validateParameter(valid_579978, JString, required = true,
                                 default = nil)
  if valid_579978 != nil:
    section.add "name", valid_579978
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
  var valid_579979 = query.getOrDefault("key")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "key", valid_579979
  var valid_579980 = query.getOrDefault("prettyPrint")
  valid_579980 = validateParameter(valid_579980, JBool, required = false,
                                 default = newJBool(true))
  if valid_579980 != nil:
    section.add "prettyPrint", valid_579980
  var valid_579981 = query.getOrDefault("oauth_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "oauth_token", valid_579981
  var valid_579982 = query.getOrDefault("$.xgafv")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("1"))
  if valid_579982 != nil:
    section.add "$.xgafv", valid_579982
  var valid_579983 = query.getOrDefault("alt")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("json"))
  if valid_579983 != nil:
    section.add "alt", valid_579983
  var valid_579984 = query.getOrDefault("uploadType")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "uploadType", valid_579984
  var valid_579985 = query.getOrDefault("quotaUser")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "quotaUser", valid_579985
  var valid_579986 = query.getOrDefault("callback")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "callback", valid_579986
  var valid_579987 = query.getOrDefault("fields")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "fields", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("upload_protocol")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "upload_protocol", valid_579989
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

proc call*(call_579991: Call_ContainerProjectsLocationsClustersStartIpRotation_579975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_579991.validator(path, query, header, formData, body)
  let scheme = call_579991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579991.url(scheme.get, call_579991.host, call_579991.base,
                         call_579991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579991, url, valid)

proc call*(call_579992: Call_ContainerProjectsLocationsClustersStartIpRotation_579975;
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
  var path_579993 = newJObject()
  var query_579994 = newJObject()
  var body_579995 = newJObject()
  add(query_579994, "key", newJString(key))
  add(query_579994, "prettyPrint", newJBool(prettyPrint))
  add(query_579994, "oauth_token", newJString(oauthToken))
  add(query_579994, "$.xgafv", newJString(Xgafv))
  add(query_579994, "alt", newJString(alt))
  add(query_579994, "uploadType", newJString(uploadType))
  add(query_579994, "quotaUser", newJString(quotaUser))
  add(path_579993, "name", newJString(name))
  if body != nil:
    body_579995 = body
  add(query_579994, "callback", newJString(callback))
  add(query_579994, "fields", newJString(fields))
  add(query_579994, "access_token", newJString(accessToken))
  add(query_579994, "upload_protocol", newJString(uploadProtocol))
  result = call_579992.call(path_579993, query_579994, nil, nil, body_579995)

var containerProjectsLocationsClustersStartIpRotation* = Call_ContainerProjectsLocationsClustersStartIpRotation_579975(
    name: "containerProjectsLocationsClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:startIpRotation",
    validator: validate_ContainerProjectsLocationsClustersStartIpRotation_579976,
    base: "/", url: url_ContainerProjectsLocationsClustersStartIpRotation_579977,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersUpdateMaster_579996 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersUpdateMaster_579998(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersUpdateMaster_579997(
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
  var valid_579999 = path.getOrDefault("name")
  valid_579999 = validateParameter(valid_579999, JString, required = true,
                                 default = nil)
  if valid_579999 != nil:
    section.add "name", valid_579999
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
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("prettyPrint")
  valid_580001 = validateParameter(valid_580001, JBool, required = false,
                                 default = newJBool(true))
  if valid_580001 != nil:
    section.add "prettyPrint", valid_580001
  var valid_580002 = query.getOrDefault("oauth_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "oauth_token", valid_580002
  var valid_580003 = query.getOrDefault("$.xgafv")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = newJString("1"))
  if valid_580003 != nil:
    section.add "$.xgafv", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("uploadType")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "uploadType", valid_580005
  var valid_580006 = query.getOrDefault("quotaUser")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "quotaUser", valid_580006
  var valid_580007 = query.getOrDefault("callback")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "callback", valid_580007
  var valid_580008 = query.getOrDefault("fields")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "fields", valid_580008
  var valid_580009 = query.getOrDefault("access_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "access_token", valid_580009
  var valid_580010 = query.getOrDefault("upload_protocol")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "upload_protocol", valid_580010
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

proc call*(call_580012: Call_ContainerProjectsLocationsClustersUpdateMaster_579996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_580012.validator(path, query, header, formData, body)
  let scheme = call_580012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580012.url(scheme.get, call_580012.host, call_580012.base,
                         call_580012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580012, url, valid)

proc call*(call_580013: Call_ContainerProjectsLocationsClustersUpdateMaster_579996;
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
  var path_580014 = newJObject()
  var query_580015 = newJObject()
  var body_580016 = newJObject()
  add(query_580015, "key", newJString(key))
  add(query_580015, "prettyPrint", newJBool(prettyPrint))
  add(query_580015, "oauth_token", newJString(oauthToken))
  add(query_580015, "$.xgafv", newJString(Xgafv))
  add(query_580015, "alt", newJString(alt))
  add(query_580015, "uploadType", newJString(uploadType))
  add(query_580015, "quotaUser", newJString(quotaUser))
  add(path_580014, "name", newJString(name))
  if body != nil:
    body_580016 = body
  add(query_580015, "callback", newJString(callback))
  add(query_580015, "fields", newJString(fields))
  add(query_580015, "access_token", newJString(accessToken))
  add(query_580015, "upload_protocol", newJString(uploadProtocol))
  result = call_580013.call(path_580014, query_580015, nil, nil, body_580016)

var containerProjectsLocationsClustersUpdateMaster* = Call_ContainerProjectsLocationsClustersUpdateMaster_579996(
    name: "containerProjectsLocationsClustersUpdateMaster",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:updateMaster",
    validator: validate_ContainerProjectsLocationsClustersUpdateMaster_579997,
    base: "/", url: url_ContainerProjectsLocationsClustersUpdateMaster_579998,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_580017 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_580019(
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

proc validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_580018(
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
  var valid_580020 = path.getOrDefault("parent")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "parent", valid_580020
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
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
  var valid_580023 = query.getOrDefault("oauth_token")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "oauth_token", valid_580023
  var valid_580024 = query.getOrDefault("$.xgafv")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("1"))
  if valid_580024 != nil:
    section.add "$.xgafv", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("uploadType")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "uploadType", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
  var valid_580028 = query.getOrDefault("callback")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "callback", valid_580028
  var valid_580029 = query.getOrDefault("fields")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "fields", valid_580029
  var valid_580030 = query.getOrDefault("access_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "access_token", valid_580030
  var valid_580031 = query.getOrDefault("upload_protocol")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "upload_protocol", valid_580031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580032: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_580017;
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
  let valid = call_580032.validator(path, query, header, formData, body)
  let scheme = call_580032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580032.url(scheme.get, call_580032.host, call_580032.base,
                         call_580032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580032, url, valid)

proc call*(call_580033: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_580017;
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
  var path_580034 = newJObject()
  var query_580035 = newJObject()
  add(query_580035, "key", newJString(key))
  add(query_580035, "prettyPrint", newJBool(prettyPrint))
  add(query_580035, "oauth_token", newJString(oauthToken))
  add(query_580035, "$.xgafv", newJString(Xgafv))
  add(query_580035, "alt", newJString(alt))
  add(query_580035, "uploadType", newJString(uploadType))
  add(query_580035, "quotaUser", newJString(quotaUser))
  add(query_580035, "callback", newJString(callback))
  add(path_580034, "parent", newJString(parent))
  add(query_580035, "fields", newJString(fields))
  add(query_580035, "access_token", newJString(accessToken))
  add(query_580035, "upload_protocol", newJString(uploadProtocol))
  result = call_580033.call(path_580034, query_580035, nil, nil, nil)

var containerProjectsLocationsClustersWellKnownGetOpenidConfiguration* = Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_580017(
    name: "containerProjectsLocationsClustersWellKnownGetOpenidConfiguration",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/.well-known/openid-configuration", validator: validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_580018,
    base: "/",
    url: url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_580019,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsAggregatedUsableSubnetworksList_580036 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsAggregatedUsableSubnetworksList_580038(
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

proc validate_ContainerProjectsAggregatedUsableSubnetworksList_580037(
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
  var valid_580039 = path.getOrDefault("parent")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "parent", valid_580039
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
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("prettyPrint")
  valid_580041 = validateParameter(valid_580041, JBool, required = false,
                                 default = newJBool(true))
  if valid_580041 != nil:
    section.add "prettyPrint", valid_580041
  var valid_580042 = query.getOrDefault("oauth_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "oauth_token", valid_580042
  var valid_580043 = query.getOrDefault("$.xgafv")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("1"))
  if valid_580043 != nil:
    section.add "$.xgafv", valid_580043
  var valid_580044 = query.getOrDefault("pageSize")
  valid_580044 = validateParameter(valid_580044, JInt, required = false, default = nil)
  if valid_580044 != nil:
    section.add "pageSize", valid_580044
  var valid_580045 = query.getOrDefault("alt")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("json"))
  if valid_580045 != nil:
    section.add "alt", valid_580045
  var valid_580046 = query.getOrDefault("uploadType")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "uploadType", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  var valid_580048 = query.getOrDefault("filter")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "filter", valid_580048
  var valid_580049 = query.getOrDefault("pageToken")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "pageToken", valid_580049
  var valid_580050 = query.getOrDefault("callback")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "callback", valid_580050
  var valid_580051 = query.getOrDefault("fields")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "fields", valid_580051
  var valid_580052 = query.getOrDefault("access_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "access_token", valid_580052
  var valid_580053 = query.getOrDefault("upload_protocol")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "upload_protocol", valid_580053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580054: Call_ContainerProjectsAggregatedUsableSubnetworksList_580036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists subnetworks that are usable for creating clusters in a project.
  ## 
  let valid = call_580054.validator(path, query, header, formData, body)
  let scheme = call_580054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580054.url(scheme.get, call_580054.host, call_580054.base,
                         call_580054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580054, url, valid)

proc call*(call_580055: Call_ContainerProjectsAggregatedUsableSubnetworksList_580036;
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
  var path_580056 = newJObject()
  var query_580057 = newJObject()
  add(query_580057, "key", newJString(key))
  add(query_580057, "prettyPrint", newJBool(prettyPrint))
  add(query_580057, "oauth_token", newJString(oauthToken))
  add(query_580057, "$.xgafv", newJString(Xgafv))
  add(query_580057, "pageSize", newJInt(pageSize))
  add(query_580057, "alt", newJString(alt))
  add(query_580057, "uploadType", newJString(uploadType))
  add(query_580057, "quotaUser", newJString(quotaUser))
  add(query_580057, "filter", newJString(filter))
  add(query_580057, "pageToken", newJString(pageToken))
  add(query_580057, "callback", newJString(callback))
  add(path_580056, "parent", newJString(parent))
  add(query_580057, "fields", newJString(fields))
  add(query_580057, "access_token", newJString(accessToken))
  add(query_580057, "upload_protocol", newJString(uploadProtocol))
  result = call_580055.call(path_580056, query_580057, nil, nil, nil)

var containerProjectsAggregatedUsableSubnetworksList* = Call_ContainerProjectsAggregatedUsableSubnetworksList_580036(
    name: "containerProjectsAggregatedUsableSubnetworksList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/aggregated/usableSubnetworks",
    validator: validate_ContainerProjectsAggregatedUsableSubnetworksList_580037,
    base: "/", url: url_ContainerProjectsAggregatedUsableSubnetworksList_580038,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCreate_580079 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersCreate_580081(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersCreate_580080(path: JsonNode;
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
  var valid_580082 = path.getOrDefault("parent")
  valid_580082 = validateParameter(valid_580082, JString, required = true,
                                 default = nil)
  if valid_580082 != nil:
    section.add "parent", valid_580082
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
  var valid_580085 = query.getOrDefault("oauth_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "oauth_token", valid_580085
  var valid_580086 = query.getOrDefault("$.xgafv")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("1"))
  if valid_580086 != nil:
    section.add "$.xgafv", valid_580086
  var valid_580087 = query.getOrDefault("alt")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("json"))
  if valid_580087 != nil:
    section.add "alt", valid_580087
  var valid_580088 = query.getOrDefault("uploadType")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "uploadType", valid_580088
  var valid_580089 = query.getOrDefault("quotaUser")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "quotaUser", valid_580089
  var valid_580090 = query.getOrDefault("callback")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "callback", valid_580090
  var valid_580091 = query.getOrDefault("fields")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "fields", valid_580091
  var valid_580092 = query.getOrDefault("access_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "access_token", valid_580092
  var valid_580093 = query.getOrDefault("upload_protocol")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "upload_protocol", valid_580093
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

proc call*(call_580095: Call_ContainerProjectsLocationsClustersCreate_580079;
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
  let valid = call_580095.validator(path, query, header, formData, body)
  let scheme = call_580095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580095.url(scheme.get, call_580095.host, call_580095.base,
                         call_580095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580095, url, valid)

proc call*(call_580096: Call_ContainerProjectsLocationsClustersCreate_580079;
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
  var path_580097 = newJObject()
  var query_580098 = newJObject()
  var body_580099 = newJObject()
  add(query_580098, "key", newJString(key))
  add(query_580098, "prettyPrint", newJBool(prettyPrint))
  add(query_580098, "oauth_token", newJString(oauthToken))
  add(query_580098, "$.xgafv", newJString(Xgafv))
  add(query_580098, "alt", newJString(alt))
  add(query_580098, "uploadType", newJString(uploadType))
  add(query_580098, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580099 = body
  add(query_580098, "callback", newJString(callback))
  add(path_580097, "parent", newJString(parent))
  add(query_580098, "fields", newJString(fields))
  add(query_580098, "access_token", newJString(accessToken))
  add(query_580098, "upload_protocol", newJString(uploadProtocol))
  result = call_580096.call(path_580097, query_580098, nil, nil, body_580099)

var containerProjectsLocationsClustersCreate* = Call_ContainerProjectsLocationsClustersCreate_580079(
    name: "containerProjectsLocationsClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersCreate_580080,
    base: "/", url: url_ContainerProjectsLocationsClustersCreate_580081,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersList_580058 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersList_580060(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersList_580059(path: JsonNode;
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
  var valid_580061 = path.getOrDefault("parent")
  valid_580061 = validateParameter(valid_580061, JString, required = true,
                                 default = nil)
  if valid_580061 != nil:
    section.add "parent", valid_580061
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
  var valid_580062 = query.getOrDefault("key")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "key", valid_580062
  var valid_580063 = query.getOrDefault("prettyPrint")
  valid_580063 = validateParameter(valid_580063, JBool, required = false,
                                 default = newJBool(true))
  if valid_580063 != nil:
    section.add "prettyPrint", valid_580063
  var valid_580064 = query.getOrDefault("oauth_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "oauth_token", valid_580064
  var valid_580065 = query.getOrDefault("$.xgafv")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("1"))
  if valid_580065 != nil:
    section.add "$.xgafv", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("uploadType")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "uploadType", valid_580067
  var valid_580068 = query.getOrDefault("quotaUser")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "quotaUser", valid_580068
  var valid_580069 = query.getOrDefault("zone")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "zone", valid_580069
  var valid_580070 = query.getOrDefault("callback")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "callback", valid_580070
  var valid_580071 = query.getOrDefault("fields")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "fields", valid_580071
  var valid_580072 = query.getOrDefault("access_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "access_token", valid_580072
  var valid_580073 = query.getOrDefault("upload_protocol")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "upload_protocol", valid_580073
  var valid_580074 = query.getOrDefault("projectId")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "projectId", valid_580074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580075: Call_ContainerProjectsLocationsClustersList_580058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_580075.validator(path, query, header, formData, body)
  let scheme = call_580075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580075.url(scheme.get, call_580075.host, call_580075.base,
                         call_580075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580075, url, valid)

proc call*(call_580076: Call_ContainerProjectsLocationsClustersList_580058;
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
  var path_580077 = newJObject()
  var query_580078 = newJObject()
  add(query_580078, "key", newJString(key))
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(query_580078, "$.xgafv", newJString(Xgafv))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "uploadType", newJString(uploadType))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(query_580078, "zone", newJString(zone))
  add(query_580078, "callback", newJString(callback))
  add(path_580077, "parent", newJString(parent))
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "access_token", newJString(accessToken))
  add(query_580078, "upload_protocol", newJString(uploadProtocol))
  add(query_580078, "projectId", newJString(projectId))
  result = call_580076.call(path_580077, query_580078, nil, nil, nil)

var containerProjectsLocationsClustersList* = Call_ContainerProjectsLocationsClustersList_580058(
    name: "containerProjectsLocationsClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersList_580059, base: "/",
    url: url_ContainerProjectsLocationsClustersList_580060,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersGetJwks_580100 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersGetJwks_580102(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersGetJwks_580101(path: JsonNode;
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
  var valid_580103 = path.getOrDefault("parent")
  valid_580103 = validateParameter(valid_580103, JString, required = true,
                                 default = nil)
  if valid_580103 != nil:
    section.add "parent", valid_580103
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
  var valid_580104 = query.getOrDefault("key")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "key", valid_580104
  var valid_580105 = query.getOrDefault("prettyPrint")
  valid_580105 = validateParameter(valid_580105, JBool, required = false,
                                 default = newJBool(true))
  if valid_580105 != nil:
    section.add "prettyPrint", valid_580105
  var valid_580106 = query.getOrDefault("oauth_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "oauth_token", valid_580106
  var valid_580107 = query.getOrDefault("$.xgafv")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("1"))
  if valid_580107 != nil:
    section.add "$.xgafv", valid_580107
  var valid_580108 = query.getOrDefault("alt")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("json"))
  if valid_580108 != nil:
    section.add "alt", valid_580108
  var valid_580109 = query.getOrDefault("uploadType")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "uploadType", valid_580109
  var valid_580110 = query.getOrDefault("quotaUser")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "quotaUser", valid_580110
  var valid_580111 = query.getOrDefault("callback")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "callback", valid_580111
  var valid_580112 = query.getOrDefault("fields")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "fields", valid_580112
  var valid_580113 = query.getOrDefault("access_token")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "access_token", valid_580113
  var valid_580114 = query.getOrDefault("upload_protocol")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "upload_protocol", valid_580114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580115: Call_ContainerProjectsLocationsClustersGetJwks_580100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  let valid = call_580115.validator(path, query, header, formData, body)
  let scheme = call_580115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580115.url(scheme.get, call_580115.host, call_580115.base,
                         call_580115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580115, url, valid)

proc call*(call_580116: Call_ContainerProjectsLocationsClustersGetJwks_580100;
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
  var path_580117 = newJObject()
  var query_580118 = newJObject()
  add(query_580118, "key", newJString(key))
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "$.xgafv", newJString(Xgafv))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "uploadType", newJString(uploadType))
  add(query_580118, "quotaUser", newJString(quotaUser))
  add(query_580118, "callback", newJString(callback))
  add(path_580117, "parent", newJString(parent))
  add(query_580118, "fields", newJString(fields))
  add(query_580118, "access_token", newJString(accessToken))
  add(query_580118, "upload_protocol", newJString(uploadProtocol))
  result = call_580116.call(path_580117, query_580118, nil, nil, nil)

var containerProjectsLocationsClustersGetJwks* = Call_ContainerProjectsLocationsClustersGetJwks_580100(
    name: "containerProjectsLocationsClustersGetJwks", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/jwks",
    validator: validate_ContainerProjectsLocationsClustersGetJwks_580101,
    base: "/", url: url_ContainerProjectsLocationsClustersGetJwks_580102,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsCreate_580141 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsCreate_580143(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsCreate_580142(
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
  var valid_580144 = path.getOrDefault("parent")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "parent", valid_580144
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
  var valid_580145 = query.getOrDefault("key")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "key", valid_580145
  var valid_580146 = query.getOrDefault("prettyPrint")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(true))
  if valid_580146 != nil:
    section.add "prettyPrint", valid_580146
  var valid_580147 = query.getOrDefault("oauth_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "oauth_token", valid_580147
  var valid_580148 = query.getOrDefault("$.xgafv")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("1"))
  if valid_580148 != nil:
    section.add "$.xgafv", valid_580148
  var valid_580149 = query.getOrDefault("alt")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("json"))
  if valid_580149 != nil:
    section.add "alt", valid_580149
  var valid_580150 = query.getOrDefault("uploadType")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "uploadType", valid_580150
  var valid_580151 = query.getOrDefault("quotaUser")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "quotaUser", valid_580151
  var valid_580152 = query.getOrDefault("callback")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "callback", valid_580152
  var valid_580153 = query.getOrDefault("fields")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "fields", valid_580153
  var valid_580154 = query.getOrDefault("access_token")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "access_token", valid_580154
  var valid_580155 = query.getOrDefault("upload_protocol")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "upload_protocol", valid_580155
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

proc call*(call_580157: Call_ContainerProjectsLocationsClustersNodePoolsCreate_580141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_580157.validator(path, query, header, formData, body)
  let scheme = call_580157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580157.url(scheme.get, call_580157.host, call_580157.base,
                         call_580157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580157, url, valid)

proc call*(call_580158: Call_ContainerProjectsLocationsClustersNodePoolsCreate_580141;
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
  var path_580159 = newJObject()
  var query_580160 = newJObject()
  var body_580161 = newJObject()
  add(query_580160, "key", newJString(key))
  add(query_580160, "prettyPrint", newJBool(prettyPrint))
  add(query_580160, "oauth_token", newJString(oauthToken))
  add(query_580160, "$.xgafv", newJString(Xgafv))
  add(query_580160, "alt", newJString(alt))
  add(query_580160, "uploadType", newJString(uploadType))
  add(query_580160, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580161 = body
  add(query_580160, "callback", newJString(callback))
  add(path_580159, "parent", newJString(parent))
  add(query_580160, "fields", newJString(fields))
  add(query_580160, "access_token", newJString(accessToken))
  add(query_580160, "upload_protocol", newJString(uploadProtocol))
  result = call_580158.call(path_580159, query_580160, nil, nil, body_580161)

var containerProjectsLocationsClustersNodePoolsCreate* = Call_ContainerProjectsLocationsClustersNodePoolsCreate_580141(
    name: "containerProjectsLocationsClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsCreate_580142,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsCreate_580143,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsList_580119 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsList_580121(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersNodePoolsList_580120(
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
  var valid_580122 = path.getOrDefault("parent")
  valid_580122 = validateParameter(valid_580122, JString, required = true,
                                 default = nil)
  if valid_580122 != nil:
    section.add "parent", valid_580122
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
  var valid_580123 = query.getOrDefault("key")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "key", valid_580123
  var valid_580124 = query.getOrDefault("prettyPrint")
  valid_580124 = validateParameter(valid_580124, JBool, required = false,
                                 default = newJBool(true))
  if valid_580124 != nil:
    section.add "prettyPrint", valid_580124
  var valid_580125 = query.getOrDefault("oauth_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "oauth_token", valid_580125
  var valid_580126 = query.getOrDefault("$.xgafv")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("1"))
  if valid_580126 != nil:
    section.add "$.xgafv", valid_580126
  var valid_580127 = query.getOrDefault("alt")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("json"))
  if valid_580127 != nil:
    section.add "alt", valid_580127
  var valid_580128 = query.getOrDefault("uploadType")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "uploadType", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("clusterId")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "clusterId", valid_580130
  var valid_580131 = query.getOrDefault("zone")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "zone", valid_580131
  var valid_580132 = query.getOrDefault("callback")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "callback", valid_580132
  var valid_580133 = query.getOrDefault("fields")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "fields", valid_580133
  var valid_580134 = query.getOrDefault("access_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "access_token", valid_580134
  var valid_580135 = query.getOrDefault("upload_protocol")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "upload_protocol", valid_580135
  var valid_580136 = query.getOrDefault("projectId")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "projectId", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_ContainerProjectsLocationsClustersNodePoolsList_580119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_ContainerProjectsLocationsClustersNodePoolsList_580119;
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
  var path_580139 = newJObject()
  var query_580140 = newJObject()
  add(query_580140, "key", newJString(key))
  add(query_580140, "prettyPrint", newJBool(prettyPrint))
  add(query_580140, "oauth_token", newJString(oauthToken))
  add(query_580140, "$.xgafv", newJString(Xgafv))
  add(query_580140, "alt", newJString(alt))
  add(query_580140, "uploadType", newJString(uploadType))
  add(query_580140, "quotaUser", newJString(quotaUser))
  add(query_580140, "clusterId", newJString(clusterId))
  add(query_580140, "zone", newJString(zone))
  add(query_580140, "callback", newJString(callback))
  add(path_580139, "parent", newJString(parent))
  add(query_580140, "fields", newJString(fields))
  add(query_580140, "access_token", newJString(accessToken))
  add(query_580140, "upload_protocol", newJString(uploadProtocol))
  add(query_580140, "projectId", newJString(projectId))
  result = call_580138.call(path_580139, query_580140, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsList* = Call_ContainerProjectsLocationsClustersNodePoolsList_580119(
    name: "containerProjectsLocationsClustersNodePoolsList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsList_580120,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsList_580121,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsList_580162 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsOperationsList_580164(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsOperationsList_580163(path: JsonNode;
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
  var valid_580165 = path.getOrDefault("parent")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "parent", valid_580165
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
  var valid_580166 = query.getOrDefault("key")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "key", valid_580166
  var valid_580167 = query.getOrDefault("prettyPrint")
  valid_580167 = validateParameter(valid_580167, JBool, required = false,
                                 default = newJBool(true))
  if valid_580167 != nil:
    section.add "prettyPrint", valid_580167
  var valid_580168 = query.getOrDefault("oauth_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "oauth_token", valid_580168
  var valid_580169 = query.getOrDefault("$.xgafv")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("1"))
  if valid_580169 != nil:
    section.add "$.xgafv", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("uploadType")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "uploadType", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("zone")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "zone", valid_580173
  var valid_580174 = query.getOrDefault("callback")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "callback", valid_580174
  var valid_580175 = query.getOrDefault("fields")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "fields", valid_580175
  var valid_580176 = query.getOrDefault("access_token")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "access_token", valid_580176
  var valid_580177 = query.getOrDefault("upload_protocol")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "upload_protocol", valid_580177
  var valid_580178 = query.getOrDefault("projectId")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "projectId", valid_580178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580179: Call_ContainerProjectsLocationsOperationsList_580162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_ContainerProjectsLocationsOperationsList_580162;
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  add(query_580182, "key", newJString(key))
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "$.xgafv", newJString(Xgafv))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "uploadType", newJString(uploadType))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "zone", newJString(zone))
  add(query_580182, "callback", newJString(callback))
  add(path_580181, "parent", newJString(parent))
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "access_token", newJString(accessToken))
  add(query_580182, "upload_protocol", newJString(uploadProtocol))
  add(query_580182, "projectId", newJString(projectId))
  result = call_580180.call(path_580181, query_580182, nil, nil, nil)

var containerProjectsLocationsOperationsList* = Call_ContainerProjectsLocationsOperationsList_580162(
    name: "containerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/operations",
    validator: validate_ContainerProjectsLocationsOperationsList_580163,
    base: "/", url: url_ContainerProjectsLocationsOperationsList_580164,
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
