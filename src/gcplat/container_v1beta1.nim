
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
  Call_ContainerProjectsZonesClustersCreate_578911 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersCreate_578913(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersCreate_578912(path: JsonNode;
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
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578914 = path.getOrDefault("projectId")
  valid_578914 = validateParameter(valid_578914, JString, required = true,
                                 default = nil)
  if valid_578914 != nil:
    section.add "projectId", valid_578914
  var valid_578915 = path.getOrDefault("zone")
  valid_578915 = validateParameter(valid_578915, JString, required = true,
                                 default = nil)
  if valid_578915 != nil:
    section.add "zone", valid_578915
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578916 = query.getOrDefault("key")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "key", valid_578916
  var valid_578917 = query.getOrDefault("pp")
  valid_578917 = validateParameter(valid_578917, JBool, required = false,
                                 default = newJBool(true))
  if valid_578917 != nil:
    section.add "pp", valid_578917
  var valid_578918 = query.getOrDefault("prettyPrint")
  valid_578918 = validateParameter(valid_578918, JBool, required = false,
                                 default = newJBool(true))
  if valid_578918 != nil:
    section.add "prettyPrint", valid_578918
  var valid_578919 = query.getOrDefault("oauth_token")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "oauth_token", valid_578919
  var valid_578920 = query.getOrDefault("$.xgafv")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = newJString("1"))
  if valid_578920 != nil:
    section.add "$.xgafv", valid_578920
  var valid_578921 = query.getOrDefault("bearer_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "bearer_token", valid_578921
  var valid_578922 = query.getOrDefault("alt")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = newJString("json"))
  if valid_578922 != nil:
    section.add "alt", valid_578922
  var valid_578923 = query.getOrDefault("uploadType")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "uploadType", valid_578923
  var valid_578924 = query.getOrDefault("quotaUser")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "quotaUser", valid_578924
  var valid_578925 = query.getOrDefault("callback")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "callback", valid_578925
  var valid_578926 = query.getOrDefault("fields")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "fields", valid_578926
  var valid_578927 = query.getOrDefault("access_token")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "access_token", valid_578927
  var valid_578928 = query.getOrDefault("upload_protocol")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "upload_protocol", valid_578928
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

proc call*(call_578930: Call_ContainerProjectsZonesClustersCreate_578911;
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
  let valid = call_578930.validator(path, query, header, formData, body)
  let scheme = call_578930.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578930.url(scheme.get, call_578930.host, call_578930.base,
                         call_578930.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578930, url, valid)

proc call*(call_578931: Call_ContainerProjectsZonesClustersCreate_578911;
          projectId: string; zone: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578932 = newJObject()
  var query_578933 = newJObject()
  var body_578934 = newJObject()
  add(query_578933, "key", newJString(key))
  add(query_578933, "pp", newJBool(pp))
  add(query_578933, "prettyPrint", newJBool(prettyPrint))
  add(query_578933, "oauth_token", newJString(oauthToken))
  add(path_578932, "projectId", newJString(projectId))
  add(query_578933, "$.xgafv", newJString(Xgafv))
  add(query_578933, "bearer_token", newJString(bearerToken))
  add(query_578933, "alt", newJString(alt))
  add(query_578933, "uploadType", newJString(uploadType))
  add(query_578933, "quotaUser", newJString(quotaUser))
  add(path_578932, "zone", newJString(zone))
  if body != nil:
    body_578934 = body
  add(query_578933, "callback", newJString(callback))
  add(query_578933, "fields", newJString(fields))
  add(query_578933, "access_token", newJString(accessToken))
  add(query_578933, "upload_protocol", newJString(uploadProtocol))
  result = call_578931.call(path_578932, query_578933, nil, nil, body_578934)

var containerProjectsZonesClustersCreate* = Call_ContainerProjectsZonesClustersCreate_578911(
    name: "containerProjectsZonesClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersCreate_578912, base: "/",
    url: url_ContainerProjectsZonesClustersCreate_578913, schemes: {Scheme.Https})
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/projects/"),
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
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578763 = query.getOrDefault("pp")
  valid_578763 = validateParameter(valid_578763, JBool, required = false,
                                 default = newJBool(true))
  if valid_578763 != nil:
    section.add "pp", valid_578763
  var valid_578764 = query.getOrDefault("prettyPrint")
  valid_578764 = validateParameter(valid_578764, JBool, required = false,
                                 default = newJBool(true))
  if valid_578764 != nil:
    section.add "prettyPrint", valid_578764
  var valid_578765 = query.getOrDefault("oauth_token")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "oauth_token", valid_578765
  var valid_578766 = query.getOrDefault("$.xgafv")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = newJString("1"))
  if valid_578766 != nil:
    section.add "$.xgafv", valid_578766
  var valid_578767 = query.getOrDefault("bearer_token")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "bearer_token", valid_578767
  var valid_578768 = query.getOrDefault("alt")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = newJString("json"))
  if valid_578768 != nil:
    section.add "alt", valid_578768
  var valid_578769 = query.getOrDefault("uploadType")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "uploadType", valid_578769
  var valid_578770 = query.getOrDefault("parent")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "parent", valid_578770
  var valid_578771 = query.getOrDefault("quotaUser")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "quotaUser", valid_578771
  var valid_578772 = query.getOrDefault("callback")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "callback", valid_578772
  var valid_578773 = query.getOrDefault("fields")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "fields", valid_578773
  var valid_578774 = query.getOrDefault("access_token")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "access_token", valid_578774
  var valid_578775 = query.getOrDefault("upload_protocol")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "upload_protocol", valid_578775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578798: Call_ContainerProjectsZonesClustersList_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_578798.validator(path, query, header, formData, body)
  let scheme = call_578798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578798.url(scheme.get, call_578798.host, call_578798.base,
                         call_578798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578798, url, valid)

proc call*(call_578869: Call_ContainerProjectsZonesClustersList_578619;
          projectId: string; zone: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          parent: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578870 = newJObject()
  var query_578872 = newJObject()
  add(query_578872, "key", newJString(key))
  add(query_578872, "pp", newJBool(pp))
  add(query_578872, "prettyPrint", newJBool(prettyPrint))
  add(query_578872, "oauth_token", newJString(oauthToken))
  add(path_578870, "projectId", newJString(projectId))
  add(query_578872, "$.xgafv", newJString(Xgafv))
  add(query_578872, "bearer_token", newJString(bearerToken))
  add(query_578872, "alt", newJString(alt))
  add(query_578872, "uploadType", newJString(uploadType))
  add(query_578872, "parent", newJString(parent))
  add(query_578872, "quotaUser", newJString(quotaUser))
  add(path_578870, "zone", newJString(zone))
  add(query_578872, "callback", newJString(callback))
  add(query_578872, "fields", newJString(fields))
  add(query_578872, "access_token", newJString(accessToken))
  add(query_578872, "upload_protocol", newJString(uploadProtocol))
  result = call_578869.call(path_578870, query_578872, nil, nil, nil)

var containerProjectsZonesClustersList* = Call_ContainerProjectsZonesClustersList_578619(
    name: "containerProjectsZonesClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersList_578620, base: "/",
    url: url_ContainerProjectsZonesClustersList_578621, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersUpdate_578959 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersUpdate_578961(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersUpdate_578960(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the settings of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578962 = path.getOrDefault("projectId")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "projectId", valid_578962
  var valid_578963 = path.getOrDefault("clusterId")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "clusterId", valid_578963
  var valid_578964 = path.getOrDefault("zone")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "zone", valid_578964
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("pp")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "pp", valid_578966
  var valid_578967 = query.getOrDefault("prettyPrint")
  valid_578967 = validateParameter(valid_578967, JBool, required = false,
                                 default = newJBool(true))
  if valid_578967 != nil:
    section.add "prettyPrint", valid_578967
  var valid_578968 = query.getOrDefault("oauth_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "oauth_token", valid_578968
  var valid_578969 = query.getOrDefault("$.xgafv")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("1"))
  if valid_578969 != nil:
    section.add "$.xgafv", valid_578969
  var valid_578970 = query.getOrDefault("bearer_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "bearer_token", valid_578970
  var valid_578971 = query.getOrDefault("alt")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("json"))
  if valid_578971 != nil:
    section.add "alt", valid_578971
  var valid_578972 = query.getOrDefault("uploadType")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "uploadType", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("callback")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "callback", valid_578974
  var valid_578975 = query.getOrDefault("fields")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "fields", valid_578975
  var valid_578976 = query.getOrDefault("access_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "access_token", valid_578976
  var valid_578977 = query.getOrDefault("upload_protocol")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "upload_protocol", valid_578977
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

proc call*(call_578979: Call_ContainerProjectsZonesClustersUpdate_578959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific cluster.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_ContainerProjectsZonesClustersUpdate_578959;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersUpdate
  ## Updates the settings of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  var body_578983 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "pp", newJBool(pp))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(path_578981, "projectId", newJString(projectId))
  add(query_578982, "$.xgafv", newJString(Xgafv))
  add(query_578982, "bearer_token", newJString(bearerToken))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "uploadType", newJString(uploadType))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(path_578981, "clusterId", newJString(clusterId))
  add(path_578981, "zone", newJString(zone))
  if body != nil:
    body_578983 = body
  add(query_578982, "callback", newJString(callback))
  add(query_578982, "fields", newJString(fields))
  add(query_578982, "access_token", newJString(accessToken))
  add(query_578982, "upload_protocol", newJString(uploadProtocol))
  result = call_578980.call(path_578981, query_578982, nil, nil, body_578983)

var containerProjectsZonesClustersUpdate* = Call_ContainerProjectsZonesClustersUpdate_578959(
    name: "containerProjectsZonesClustersUpdate", meth: HttpMethod.HttpPut,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersUpdate_578960, base: "/",
    url: url_ContainerProjectsZonesClustersUpdate_578961, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersGet_578935 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersGet_578937(protocol: Scheme; host: string;
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

proc validate_ContainerProjectsZonesClustersGet_578936(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to retrieve.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578938 = path.getOrDefault("projectId")
  valid_578938 = validateParameter(valid_578938, JString, required = true,
                                 default = nil)
  if valid_578938 != nil:
    section.add "projectId", valid_578938
  var valid_578939 = path.getOrDefault("clusterId")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "clusterId", valid_578939
  var valid_578940 = path.getOrDefault("zone")
  valid_578940 = validateParameter(valid_578940, JString, required = true,
                                 default = nil)
  if valid_578940 != nil:
    section.add "zone", valid_578940
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, cluster) of the cluster to retrieve.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578941 = query.getOrDefault("key")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "key", valid_578941
  var valid_578942 = query.getOrDefault("pp")
  valid_578942 = validateParameter(valid_578942, JBool, required = false,
                                 default = newJBool(true))
  if valid_578942 != nil:
    section.add "pp", valid_578942
  var valid_578943 = query.getOrDefault("prettyPrint")
  valid_578943 = validateParameter(valid_578943, JBool, required = false,
                                 default = newJBool(true))
  if valid_578943 != nil:
    section.add "prettyPrint", valid_578943
  var valid_578944 = query.getOrDefault("oauth_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "oauth_token", valid_578944
  var valid_578945 = query.getOrDefault("name")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "name", valid_578945
  var valid_578946 = query.getOrDefault("$.xgafv")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("1"))
  if valid_578946 != nil:
    section.add "$.xgafv", valid_578946
  var valid_578947 = query.getOrDefault("bearer_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "bearer_token", valid_578947
  var valid_578948 = query.getOrDefault("alt")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("json"))
  if valid_578948 != nil:
    section.add "alt", valid_578948
  var valid_578949 = query.getOrDefault("uploadType")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "uploadType", valid_578949
  var valid_578950 = query.getOrDefault("quotaUser")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "quotaUser", valid_578950
  var valid_578951 = query.getOrDefault("callback")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "callback", valid_578951
  var valid_578952 = query.getOrDefault("fields")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "fields", valid_578952
  var valid_578953 = query.getOrDefault("access_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "access_token", valid_578953
  var valid_578954 = query.getOrDefault("upload_protocol")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "upload_protocol", valid_578954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578955: Call_ContainerProjectsZonesClustersGet_578935;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific cluster.
  ## 
  let valid = call_578955.validator(path, query, header, formData, body)
  let scheme = call_578955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578955.url(scheme.get, call_578955.host, call_578955.base,
                         call_578955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578955, url, valid)

proc call*(call_578956: Call_ContainerProjectsZonesClustersGet_578935;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersGet
  ## Gets the details of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project, location, cluster) of the cluster to retrieve.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to retrieve.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578957 = newJObject()
  var query_578958 = newJObject()
  add(query_578958, "key", newJString(key))
  add(query_578958, "pp", newJBool(pp))
  add(query_578958, "prettyPrint", newJBool(prettyPrint))
  add(query_578958, "oauth_token", newJString(oauthToken))
  add(query_578958, "name", newJString(name))
  add(path_578957, "projectId", newJString(projectId))
  add(query_578958, "$.xgafv", newJString(Xgafv))
  add(query_578958, "bearer_token", newJString(bearerToken))
  add(query_578958, "alt", newJString(alt))
  add(query_578958, "uploadType", newJString(uploadType))
  add(query_578958, "quotaUser", newJString(quotaUser))
  add(path_578957, "clusterId", newJString(clusterId))
  add(path_578957, "zone", newJString(zone))
  add(query_578958, "callback", newJString(callback))
  add(query_578958, "fields", newJString(fields))
  add(query_578958, "access_token", newJString(accessToken))
  add(query_578958, "upload_protocol", newJString(uploadProtocol))
  result = call_578956.call(path_578957, query_578958, nil, nil, nil)

var containerProjectsZonesClustersGet* = Call_ContainerProjectsZonesClustersGet_578935(
    name: "containerProjectsZonesClustersGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersGet_578936, base: "/",
    url: url_ContainerProjectsZonesClustersGet_578937, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersDelete_578984 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersDelete_578986(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersDelete_578985(path: JsonNode;
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
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to delete.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578987 = path.getOrDefault("projectId")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = nil)
  if valid_578987 != nil:
    section.add "projectId", valid_578987
  var valid_578988 = path.getOrDefault("clusterId")
  valid_578988 = validateParameter(valid_578988, JString, required = true,
                                 default = nil)
  if valid_578988 != nil:
    section.add "clusterId", valid_578988
  var valid_578989 = path.getOrDefault("zone")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "zone", valid_578989
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, cluster) of the cluster to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("pp")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "pp", valid_578991
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
  var valid_578994 = query.getOrDefault("name")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "name", valid_578994
  var valid_578995 = query.getOrDefault("$.xgafv")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("1"))
  if valid_578995 != nil:
    section.add "$.xgafv", valid_578995
  var valid_578996 = query.getOrDefault("bearer_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "bearer_token", valid_578996
  var valid_578997 = query.getOrDefault("alt")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("json"))
  if valid_578997 != nil:
    section.add "alt", valid_578997
  var valid_578998 = query.getOrDefault("uploadType")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "uploadType", valid_578998
  var valid_578999 = query.getOrDefault("quotaUser")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "quotaUser", valid_578999
  var valid_579000 = query.getOrDefault("callback")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "callback", valid_579000
  var valid_579001 = query.getOrDefault("fields")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "fields", valid_579001
  var valid_579002 = query.getOrDefault("access_token")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "access_token", valid_579002
  var valid_579003 = query.getOrDefault("upload_protocol")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "upload_protocol", valid_579003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579004: Call_ContainerProjectsZonesClustersDelete_578984;
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
  let valid = call_579004.validator(path, query, header, formData, body)
  let scheme = call_579004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579004.url(scheme.get, call_579004.host, call_579004.base,
                         call_579004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579004, url, valid)

proc call*(call_579005: Call_ContainerProjectsZonesClustersDelete_578984;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project, location, cluster) of the cluster to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to delete.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579006 = newJObject()
  var query_579007 = newJObject()
  add(query_579007, "key", newJString(key))
  add(query_579007, "pp", newJBool(pp))
  add(query_579007, "prettyPrint", newJBool(prettyPrint))
  add(query_579007, "oauth_token", newJString(oauthToken))
  add(query_579007, "name", newJString(name))
  add(path_579006, "projectId", newJString(projectId))
  add(query_579007, "$.xgafv", newJString(Xgafv))
  add(query_579007, "bearer_token", newJString(bearerToken))
  add(query_579007, "alt", newJString(alt))
  add(query_579007, "uploadType", newJString(uploadType))
  add(query_579007, "quotaUser", newJString(quotaUser))
  add(path_579006, "clusterId", newJString(clusterId))
  add(path_579006, "zone", newJString(zone))
  add(query_579007, "callback", newJString(callback))
  add(query_579007, "fields", newJString(fields))
  add(query_579007, "access_token", newJString(accessToken))
  add(query_579007, "upload_protocol", newJString(uploadProtocol))
  result = call_579005.call(path_579006, query_579007, nil, nil, nil)

var containerProjectsZonesClustersDelete* = Call_ContainerProjectsZonesClustersDelete_578984(
    name: "containerProjectsZonesClustersDelete", meth: HttpMethod.HttpDelete,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersDelete_578985, base: "/",
    url: url_ContainerProjectsZonesClustersDelete_578986, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersAddons_579008 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersAddons_579010(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersAddons_579009(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the addons of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579011 = path.getOrDefault("projectId")
  valid_579011 = validateParameter(valid_579011, JString, required = true,
                                 default = nil)
  if valid_579011 != nil:
    section.add "projectId", valid_579011
  var valid_579012 = path.getOrDefault("clusterId")
  valid_579012 = validateParameter(valid_579012, JString, required = true,
                                 default = nil)
  if valid_579012 != nil:
    section.add "clusterId", valid_579012
  var valid_579013 = path.getOrDefault("zone")
  valid_579013 = validateParameter(valid_579013, JString, required = true,
                                 default = nil)
  if valid_579013 != nil:
    section.add "zone", valid_579013
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579014 = query.getOrDefault("key")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "key", valid_579014
  var valid_579015 = query.getOrDefault("pp")
  valid_579015 = validateParameter(valid_579015, JBool, required = false,
                                 default = newJBool(true))
  if valid_579015 != nil:
    section.add "pp", valid_579015
  var valid_579016 = query.getOrDefault("prettyPrint")
  valid_579016 = validateParameter(valid_579016, JBool, required = false,
                                 default = newJBool(true))
  if valid_579016 != nil:
    section.add "prettyPrint", valid_579016
  var valid_579017 = query.getOrDefault("oauth_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "oauth_token", valid_579017
  var valid_579018 = query.getOrDefault("$.xgafv")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("1"))
  if valid_579018 != nil:
    section.add "$.xgafv", valid_579018
  var valid_579019 = query.getOrDefault("bearer_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "bearer_token", valid_579019
  var valid_579020 = query.getOrDefault("alt")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("json"))
  if valid_579020 != nil:
    section.add "alt", valid_579020
  var valid_579021 = query.getOrDefault("uploadType")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "uploadType", valid_579021
  var valid_579022 = query.getOrDefault("quotaUser")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "quotaUser", valid_579022
  var valid_579023 = query.getOrDefault("callback")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "callback", valid_579023
  var valid_579024 = query.getOrDefault("fields")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "fields", valid_579024
  var valid_579025 = query.getOrDefault("access_token")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "access_token", valid_579025
  var valid_579026 = query.getOrDefault("upload_protocol")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "upload_protocol", valid_579026
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

proc call*(call_579028: Call_ContainerProjectsZonesClustersAddons_579008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons of a specific cluster.
  ## 
  let valid = call_579028.validator(path, query, header, formData, body)
  let scheme = call_579028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579028.url(scheme.get, call_579028.host, call_579028.base,
                         call_579028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579028, url, valid)

proc call*(call_579029: Call_ContainerProjectsZonesClustersAddons_579008;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersAddons
  ## Sets the addons of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579030 = newJObject()
  var query_579031 = newJObject()
  var body_579032 = newJObject()
  add(query_579031, "key", newJString(key))
  add(query_579031, "pp", newJBool(pp))
  add(query_579031, "prettyPrint", newJBool(prettyPrint))
  add(query_579031, "oauth_token", newJString(oauthToken))
  add(path_579030, "projectId", newJString(projectId))
  add(query_579031, "$.xgafv", newJString(Xgafv))
  add(query_579031, "bearer_token", newJString(bearerToken))
  add(query_579031, "alt", newJString(alt))
  add(query_579031, "uploadType", newJString(uploadType))
  add(query_579031, "quotaUser", newJString(quotaUser))
  add(path_579030, "clusterId", newJString(clusterId))
  add(path_579030, "zone", newJString(zone))
  if body != nil:
    body_579032 = body
  add(query_579031, "callback", newJString(callback))
  add(query_579031, "fields", newJString(fields))
  add(query_579031, "access_token", newJString(accessToken))
  add(query_579031, "upload_protocol", newJString(uploadProtocol))
  result = call_579029.call(path_579030, query_579031, nil, nil, body_579032)

var containerProjectsZonesClustersAddons* = Call_ContainerProjectsZonesClustersAddons_579008(
    name: "containerProjectsZonesClustersAddons", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/addons",
    validator: validate_ContainerProjectsZonesClustersAddons_579009, base: "/",
    url: url_ContainerProjectsZonesClustersAddons_579010, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLegacyAbac_579033 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersLegacyAbac_579035(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersLegacyAbac_579034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579036 = path.getOrDefault("projectId")
  valid_579036 = validateParameter(valid_579036, JString, required = true,
                                 default = nil)
  if valid_579036 != nil:
    section.add "projectId", valid_579036
  var valid_579037 = path.getOrDefault("clusterId")
  valid_579037 = validateParameter(valid_579037, JString, required = true,
                                 default = nil)
  if valid_579037 != nil:
    section.add "clusterId", valid_579037
  var valid_579038 = path.getOrDefault("zone")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "zone", valid_579038
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579039 = query.getOrDefault("key")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "key", valid_579039
  var valid_579040 = query.getOrDefault("pp")
  valid_579040 = validateParameter(valid_579040, JBool, required = false,
                                 default = newJBool(true))
  if valid_579040 != nil:
    section.add "pp", valid_579040
  var valid_579041 = query.getOrDefault("prettyPrint")
  valid_579041 = validateParameter(valid_579041, JBool, required = false,
                                 default = newJBool(true))
  if valid_579041 != nil:
    section.add "prettyPrint", valid_579041
  var valid_579042 = query.getOrDefault("oauth_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "oauth_token", valid_579042
  var valid_579043 = query.getOrDefault("$.xgafv")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("1"))
  if valid_579043 != nil:
    section.add "$.xgafv", valid_579043
  var valid_579044 = query.getOrDefault("bearer_token")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "bearer_token", valid_579044
  var valid_579045 = query.getOrDefault("alt")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = newJString("json"))
  if valid_579045 != nil:
    section.add "alt", valid_579045
  var valid_579046 = query.getOrDefault("uploadType")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "uploadType", valid_579046
  var valid_579047 = query.getOrDefault("quotaUser")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "quotaUser", valid_579047
  var valid_579048 = query.getOrDefault("callback")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "callback", valid_579048
  var valid_579049 = query.getOrDefault("fields")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "fields", valid_579049
  var valid_579050 = query.getOrDefault("access_token")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "access_token", valid_579050
  var valid_579051 = query.getOrDefault("upload_protocol")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "upload_protocol", valid_579051
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

proc call*(call_579053: Call_ContainerProjectsZonesClustersLegacyAbac_579033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_579053.validator(path, query, header, formData, body)
  let scheme = call_579053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579053.url(scheme.get, call_579053.host, call_579053.base,
                         call_579053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579053, url, valid)

proc call*(call_579054: Call_ContainerProjectsZonesClustersLegacyAbac_579033;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579055 = newJObject()
  var query_579056 = newJObject()
  var body_579057 = newJObject()
  add(query_579056, "key", newJString(key))
  add(query_579056, "pp", newJBool(pp))
  add(query_579056, "prettyPrint", newJBool(prettyPrint))
  add(query_579056, "oauth_token", newJString(oauthToken))
  add(path_579055, "projectId", newJString(projectId))
  add(query_579056, "$.xgafv", newJString(Xgafv))
  add(query_579056, "bearer_token", newJString(bearerToken))
  add(query_579056, "alt", newJString(alt))
  add(query_579056, "uploadType", newJString(uploadType))
  add(query_579056, "quotaUser", newJString(quotaUser))
  add(path_579055, "clusterId", newJString(clusterId))
  add(path_579055, "zone", newJString(zone))
  if body != nil:
    body_579057 = body
  add(query_579056, "callback", newJString(callback))
  add(query_579056, "fields", newJString(fields))
  add(query_579056, "access_token", newJString(accessToken))
  add(query_579056, "upload_protocol", newJString(uploadProtocol))
  result = call_579054.call(path_579055, query_579056, nil, nil, body_579057)

var containerProjectsZonesClustersLegacyAbac* = Call_ContainerProjectsZonesClustersLegacyAbac_579033(
    name: "containerProjectsZonesClustersLegacyAbac", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/legacyAbac",
    validator: validate_ContainerProjectsZonesClustersLegacyAbac_579034,
    base: "/", url: url_ContainerProjectsZonesClustersLegacyAbac_579035,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLocations_579058 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersLocations_579060(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersLocations_579059(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the locations of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579061 = path.getOrDefault("projectId")
  valid_579061 = validateParameter(valid_579061, JString, required = true,
                                 default = nil)
  if valid_579061 != nil:
    section.add "projectId", valid_579061
  var valid_579062 = path.getOrDefault("clusterId")
  valid_579062 = validateParameter(valid_579062, JString, required = true,
                                 default = nil)
  if valid_579062 != nil:
    section.add "clusterId", valid_579062
  var valid_579063 = path.getOrDefault("zone")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "zone", valid_579063
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("pp")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "pp", valid_579065
  var valid_579066 = query.getOrDefault("prettyPrint")
  valid_579066 = validateParameter(valid_579066, JBool, required = false,
                                 default = newJBool(true))
  if valid_579066 != nil:
    section.add "prettyPrint", valid_579066
  var valid_579067 = query.getOrDefault("oauth_token")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "oauth_token", valid_579067
  var valid_579068 = query.getOrDefault("$.xgafv")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = newJString("1"))
  if valid_579068 != nil:
    section.add "$.xgafv", valid_579068
  var valid_579069 = query.getOrDefault("bearer_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "bearer_token", valid_579069
  var valid_579070 = query.getOrDefault("alt")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("json"))
  if valid_579070 != nil:
    section.add "alt", valid_579070
  var valid_579071 = query.getOrDefault("uploadType")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "uploadType", valid_579071
  var valid_579072 = query.getOrDefault("quotaUser")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "quotaUser", valid_579072
  var valid_579073 = query.getOrDefault("callback")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "callback", valid_579073
  var valid_579074 = query.getOrDefault("fields")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "fields", valid_579074
  var valid_579075 = query.getOrDefault("access_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "access_token", valid_579075
  var valid_579076 = query.getOrDefault("upload_protocol")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "upload_protocol", valid_579076
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

proc call*(call_579078: Call_ContainerProjectsZonesClustersLocations_579058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations of a specific cluster.
  ## 
  let valid = call_579078.validator(path, query, header, formData, body)
  let scheme = call_579078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579078.url(scheme.get, call_579078.host, call_579078.base,
                         call_579078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579078, url, valid)

proc call*(call_579079: Call_ContainerProjectsZonesClustersLocations_579058;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersLocations
  ## Sets the locations of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579080 = newJObject()
  var query_579081 = newJObject()
  var body_579082 = newJObject()
  add(query_579081, "key", newJString(key))
  add(query_579081, "pp", newJBool(pp))
  add(query_579081, "prettyPrint", newJBool(prettyPrint))
  add(query_579081, "oauth_token", newJString(oauthToken))
  add(path_579080, "projectId", newJString(projectId))
  add(query_579081, "$.xgafv", newJString(Xgafv))
  add(query_579081, "bearer_token", newJString(bearerToken))
  add(query_579081, "alt", newJString(alt))
  add(query_579081, "uploadType", newJString(uploadType))
  add(query_579081, "quotaUser", newJString(quotaUser))
  add(path_579080, "clusterId", newJString(clusterId))
  add(path_579080, "zone", newJString(zone))
  if body != nil:
    body_579082 = body
  add(query_579081, "callback", newJString(callback))
  add(query_579081, "fields", newJString(fields))
  add(query_579081, "access_token", newJString(accessToken))
  add(query_579081, "upload_protocol", newJString(uploadProtocol))
  result = call_579079.call(path_579080, query_579081, nil, nil, body_579082)

var containerProjectsZonesClustersLocations* = Call_ContainerProjectsZonesClustersLocations_579058(
    name: "containerProjectsZonesClustersLocations", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/locations",
    validator: validate_ContainerProjectsZonesClustersLocations_579059, base: "/",
    url: url_ContainerProjectsZonesClustersLocations_579060,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLogging_579083 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersLogging_579085(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersLogging_579084(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the logging service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579086 = path.getOrDefault("projectId")
  valid_579086 = validateParameter(valid_579086, JString, required = true,
                                 default = nil)
  if valid_579086 != nil:
    section.add "projectId", valid_579086
  var valid_579087 = path.getOrDefault("clusterId")
  valid_579087 = validateParameter(valid_579087, JString, required = true,
                                 default = nil)
  if valid_579087 != nil:
    section.add "clusterId", valid_579087
  var valid_579088 = path.getOrDefault("zone")
  valid_579088 = validateParameter(valid_579088, JString, required = true,
                                 default = nil)
  if valid_579088 != nil:
    section.add "zone", valid_579088
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579089 = query.getOrDefault("key")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "key", valid_579089
  var valid_579090 = query.getOrDefault("pp")
  valid_579090 = validateParameter(valid_579090, JBool, required = false,
                                 default = newJBool(true))
  if valid_579090 != nil:
    section.add "pp", valid_579090
  var valid_579091 = query.getOrDefault("prettyPrint")
  valid_579091 = validateParameter(valid_579091, JBool, required = false,
                                 default = newJBool(true))
  if valid_579091 != nil:
    section.add "prettyPrint", valid_579091
  var valid_579092 = query.getOrDefault("oauth_token")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "oauth_token", valid_579092
  var valid_579093 = query.getOrDefault("$.xgafv")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = newJString("1"))
  if valid_579093 != nil:
    section.add "$.xgafv", valid_579093
  var valid_579094 = query.getOrDefault("bearer_token")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "bearer_token", valid_579094
  var valid_579095 = query.getOrDefault("alt")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = newJString("json"))
  if valid_579095 != nil:
    section.add "alt", valid_579095
  var valid_579096 = query.getOrDefault("uploadType")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "uploadType", valid_579096
  var valid_579097 = query.getOrDefault("quotaUser")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "quotaUser", valid_579097
  var valid_579098 = query.getOrDefault("callback")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "callback", valid_579098
  var valid_579099 = query.getOrDefault("fields")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "fields", valid_579099
  var valid_579100 = query.getOrDefault("access_token")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "access_token", valid_579100
  var valid_579101 = query.getOrDefault("upload_protocol")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "upload_protocol", valid_579101
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

proc call*(call_579103: Call_ContainerProjectsZonesClustersLogging_579083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service of a specific cluster.
  ## 
  let valid = call_579103.validator(path, query, header, formData, body)
  let scheme = call_579103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579103.url(scheme.get, call_579103.host, call_579103.base,
                         call_579103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579103, url, valid)

proc call*(call_579104: Call_ContainerProjectsZonesClustersLogging_579083;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersLogging
  ## Sets the logging service of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
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
  var path_579105 = newJObject()
  var query_579106 = newJObject()
  var body_579107 = newJObject()
  add(query_579106, "key", newJString(key))
  add(query_579106, "pp", newJBool(pp))
  add(query_579106, "prettyPrint", newJBool(prettyPrint))
  add(query_579106, "oauth_token", newJString(oauthToken))
  add(path_579105, "projectId", newJString(projectId))
  add(query_579106, "$.xgafv", newJString(Xgafv))
  add(query_579106, "bearer_token", newJString(bearerToken))
  add(query_579106, "alt", newJString(alt))
  add(query_579106, "uploadType", newJString(uploadType))
  add(query_579106, "quotaUser", newJString(quotaUser))
  add(path_579105, "clusterId", newJString(clusterId))
  add(path_579105, "zone", newJString(zone))
  if body != nil:
    body_579107 = body
  add(query_579106, "callback", newJString(callback))
  add(query_579106, "fields", newJString(fields))
  add(query_579106, "access_token", newJString(accessToken))
  add(query_579106, "upload_protocol", newJString(uploadProtocol))
  result = call_579104.call(path_579105, query_579106, nil, nil, body_579107)

var containerProjectsZonesClustersLogging* = Call_ContainerProjectsZonesClustersLogging_579083(
    name: "containerProjectsZonesClustersLogging", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/logging",
    validator: validate_ContainerProjectsZonesClustersLogging_579084, base: "/",
    url: url_ContainerProjectsZonesClustersLogging_579085, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMaster_579108 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersMaster_579110(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersMaster_579109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the master of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579111 = path.getOrDefault("projectId")
  valid_579111 = validateParameter(valid_579111, JString, required = true,
                                 default = nil)
  if valid_579111 != nil:
    section.add "projectId", valid_579111
  var valid_579112 = path.getOrDefault("clusterId")
  valid_579112 = validateParameter(valid_579112, JString, required = true,
                                 default = nil)
  if valid_579112 != nil:
    section.add "clusterId", valid_579112
  var valid_579113 = path.getOrDefault("zone")
  valid_579113 = validateParameter(valid_579113, JString, required = true,
                                 default = nil)
  if valid_579113 != nil:
    section.add "zone", valid_579113
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579114 = query.getOrDefault("key")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "key", valid_579114
  var valid_579115 = query.getOrDefault("pp")
  valid_579115 = validateParameter(valid_579115, JBool, required = false,
                                 default = newJBool(true))
  if valid_579115 != nil:
    section.add "pp", valid_579115
  var valid_579116 = query.getOrDefault("prettyPrint")
  valid_579116 = validateParameter(valid_579116, JBool, required = false,
                                 default = newJBool(true))
  if valid_579116 != nil:
    section.add "prettyPrint", valid_579116
  var valid_579117 = query.getOrDefault("oauth_token")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "oauth_token", valid_579117
  var valid_579118 = query.getOrDefault("$.xgafv")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = newJString("1"))
  if valid_579118 != nil:
    section.add "$.xgafv", valid_579118
  var valid_579119 = query.getOrDefault("bearer_token")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "bearer_token", valid_579119
  var valid_579120 = query.getOrDefault("alt")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = newJString("json"))
  if valid_579120 != nil:
    section.add "alt", valid_579120
  var valid_579121 = query.getOrDefault("uploadType")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "uploadType", valid_579121
  var valid_579122 = query.getOrDefault("quotaUser")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "quotaUser", valid_579122
  var valid_579123 = query.getOrDefault("callback")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "callback", valid_579123
  var valid_579124 = query.getOrDefault("fields")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "fields", valid_579124
  var valid_579125 = query.getOrDefault("access_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "access_token", valid_579125
  var valid_579126 = query.getOrDefault("upload_protocol")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "upload_protocol", valid_579126
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

proc call*(call_579128: Call_ContainerProjectsZonesClustersMaster_579108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master of a specific cluster.
  ## 
  let valid = call_579128.validator(path, query, header, formData, body)
  let scheme = call_579128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579128.url(scheme.get, call_579128.host, call_579128.base,
                         call_579128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579128, url, valid)

proc call*(call_579129: Call_ContainerProjectsZonesClustersMaster_579108;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersMaster
  ## Updates the master of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579130 = newJObject()
  var query_579131 = newJObject()
  var body_579132 = newJObject()
  add(query_579131, "key", newJString(key))
  add(query_579131, "pp", newJBool(pp))
  add(query_579131, "prettyPrint", newJBool(prettyPrint))
  add(query_579131, "oauth_token", newJString(oauthToken))
  add(path_579130, "projectId", newJString(projectId))
  add(query_579131, "$.xgafv", newJString(Xgafv))
  add(query_579131, "bearer_token", newJString(bearerToken))
  add(query_579131, "alt", newJString(alt))
  add(query_579131, "uploadType", newJString(uploadType))
  add(query_579131, "quotaUser", newJString(quotaUser))
  add(path_579130, "clusterId", newJString(clusterId))
  add(path_579130, "zone", newJString(zone))
  if body != nil:
    body_579132 = body
  add(query_579131, "callback", newJString(callback))
  add(query_579131, "fields", newJString(fields))
  add(query_579131, "access_token", newJString(accessToken))
  add(query_579131, "upload_protocol", newJString(uploadProtocol))
  result = call_579129.call(path_579130, query_579131, nil, nil, body_579132)

var containerProjectsZonesClustersMaster* = Call_ContainerProjectsZonesClustersMaster_579108(
    name: "containerProjectsZonesClustersMaster", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/master",
    validator: validate_ContainerProjectsZonesClustersMaster_579109, base: "/",
    url: url_ContainerProjectsZonesClustersMaster_579110, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMonitoring_579133 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersMonitoring_579135(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersMonitoring_579134(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the monitoring service of a specific cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579136 = path.getOrDefault("projectId")
  valid_579136 = validateParameter(valid_579136, JString, required = true,
                                 default = nil)
  if valid_579136 != nil:
    section.add "projectId", valid_579136
  var valid_579137 = path.getOrDefault("clusterId")
  valid_579137 = validateParameter(valid_579137, JString, required = true,
                                 default = nil)
  if valid_579137 != nil:
    section.add "clusterId", valid_579137
  var valid_579138 = path.getOrDefault("zone")
  valid_579138 = validateParameter(valid_579138, JString, required = true,
                                 default = nil)
  if valid_579138 != nil:
    section.add "zone", valid_579138
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("pp")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "pp", valid_579140
  var valid_579141 = query.getOrDefault("prettyPrint")
  valid_579141 = validateParameter(valid_579141, JBool, required = false,
                                 default = newJBool(true))
  if valid_579141 != nil:
    section.add "prettyPrint", valid_579141
  var valid_579142 = query.getOrDefault("oauth_token")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "oauth_token", valid_579142
  var valid_579143 = query.getOrDefault("$.xgafv")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = newJString("1"))
  if valid_579143 != nil:
    section.add "$.xgafv", valid_579143
  var valid_579144 = query.getOrDefault("bearer_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "bearer_token", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("uploadType")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "uploadType", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("callback")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "callback", valid_579148
  var valid_579149 = query.getOrDefault("fields")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "fields", valid_579149
  var valid_579150 = query.getOrDefault("access_token")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "access_token", valid_579150
  var valid_579151 = query.getOrDefault("upload_protocol")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "upload_protocol", valid_579151
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

proc call*(call_579153: Call_ContainerProjectsZonesClustersMonitoring_579133;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service of a specific cluster.
  ## 
  let valid = call_579153.validator(path, query, header, formData, body)
  let scheme = call_579153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579153.url(scheme.get, call_579153.host, call_579153.base,
                         call_579153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579153, url, valid)

proc call*(call_579154: Call_ContainerProjectsZonesClustersMonitoring_579133;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersMonitoring
  ## Sets the monitoring service of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579155 = newJObject()
  var query_579156 = newJObject()
  var body_579157 = newJObject()
  add(query_579156, "key", newJString(key))
  add(query_579156, "pp", newJBool(pp))
  add(query_579156, "prettyPrint", newJBool(prettyPrint))
  add(query_579156, "oauth_token", newJString(oauthToken))
  add(path_579155, "projectId", newJString(projectId))
  add(query_579156, "$.xgafv", newJString(Xgafv))
  add(query_579156, "bearer_token", newJString(bearerToken))
  add(query_579156, "alt", newJString(alt))
  add(query_579156, "uploadType", newJString(uploadType))
  add(query_579156, "quotaUser", newJString(quotaUser))
  add(path_579155, "clusterId", newJString(clusterId))
  add(path_579155, "zone", newJString(zone))
  if body != nil:
    body_579157 = body
  add(query_579156, "callback", newJString(callback))
  add(query_579156, "fields", newJString(fields))
  add(query_579156, "access_token", newJString(accessToken))
  add(query_579156, "upload_protocol", newJString(uploadProtocol))
  result = call_579154.call(path_579155, query_579156, nil, nil, body_579157)

var containerProjectsZonesClustersMonitoring* = Call_ContainerProjectsZonesClustersMonitoring_579133(
    name: "containerProjectsZonesClustersMonitoring", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/monitoring",
    validator: validate_ContainerProjectsZonesClustersMonitoring_579134,
    base: "/", url: url_ContainerProjectsZonesClustersMonitoring_579135,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsCreate_579182 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsCreate_579184(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsCreate_579183(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a node pool for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579185 = path.getOrDefault("projectId")
  valid_579185 = validateParameter(valid_579185, JString, required = true,
                                 default = nil)
  if valid_579185 != nil:
    section.add "projectId", valid_579185
  var valid_579186 = path.getOrDefault("clusterId")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "clusterId", valid_579186
  var valid_579187 = path.getOrDefault("zone")
  valid_579187 = validateParameter(valid_579187, JString, required = true,
                                 default = nil)
  if valid_579187 != nil:
    section.add "zone", valid_579187
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579189 = query.getOrDefault("pp")
  valid_579189 = validateParameter(valid_579189, JBool, required = false,
                                 default = newJBool(true))
  if valid_579189 != nil:
    section.add "pp", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
  var valid_579192 = query.getOrDefault("$.xgafv")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("1"))
  if valid_579192 != nil:
    section.add "$.xgafv", valid_579192
  var valid_579193 = query.getOrDefault("bearer_token")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "bearer_token", valid_579193
  var valid_579194 = query.getOrDefault("alt")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = newJString("json"))
  if valid_579194 != nil:
    section.add "alt", valid_579194
  var valid_579195 = query.getOrDefault("uploadType")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "uploadType", valid_579195
  var valid_579196 = query.getOrDefault("quotaUser")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "quotaUser", valid_579196
  var valid_579197 = query.getOrDefault("callback")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "callback", valid_579197
  var valid_579198 = query.getOrDefault("fields")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "fields", valid_579198
  var valid_579199 = query.getOrDefault("access_token")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "access_token", valid_579199
  var valid_579200 = query.getOrDefault("upload_protocol")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "upload_protocol", valid_579200
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

proc call*(call_579202: Call_ContainerProjectsZonesClustersNodePoolsCreate_579182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_579202.validator(path, query, header, formData, body)
  let scheme = call_579202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579202.url(scheme.get, call_579202.host, call_579202.base,
                         call_579202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579202, url, valid)

proc call*(call_579203: Call_ContainerProjectsZonesClustersNodePoolsCreate_579182;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579204 = newJObject()
  var query_579205 = newJObject()
  var body_579206 = newJObject()
  add(query_579205, "key", newJString(key))
  add(query_579205, "pp", newJBool(pp))
  add(query_579205, "prettyPrint", newJBool(prettyPrint))
  add(query_579205, "oauth_token", newJString(oauthToken))
  add(path_579204, "projectId", newJString(projectId))
  add(query_579205, "$.xgafv", newJString(Xgafv))
  add(query_579205, "bearer_token", newJString(bearerToken))
  add(query_579205, "alt", newJString(alt))
  add(query_579205, "uploadType", newJString(uploadType))
  add(query_579205, "quotaUser", newJString(quotaUser))
  add(path_579204, "clusterId", newJString(clusterId))
  add(path_579204, "zone", newJString(zone))
  if body != nil:
    body_579206 = body
  add(query_579205, "callback", newJString(callback))
  add(query_579205, "fields", newJString(fields))
  add(query_579205, "access_token", newJString(accessToken))
  add(query_579205, "upload_protocol", newJString(uploadProtocol))
  result = call_579203.call(path_579204, query_579205, nil, nil, body_579206)

var containerProjectsZonesClustersNodePoolsCreate* = Call_ContainerProjectsZonesClustersNodePoolsCreate_579182(
    name: "containerProjectsZonesClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsCreate_579183,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsCreate_579184,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsList_579158 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsList_579160(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsList_579159(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the node pools for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
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
  var valid_579165 = query.getOrDefault("pp")
  valid_579165 = validateParameter(valid_579165, JBool, required = false,
                                 default = newJBool(true))
  if valid_579165 != nil:
    section.add "pp", valid_579165
  var valid_579166 = query.getOrDefault("prettyPrint")
  valid_579166 = validateParameter(valid_579166, JBool, required = false,
                                 default = newJBool(true))
  if valid_579166 != nil:
    section.add "prettyPrint", valid_579166
  var valid_579167 = query.getOrDefault("oauth_token")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "oauth_token", valid_579167
  var valid_579168 = query.getOrDefault("$.xgafv")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = newJString("1"))
  if valid_579168 != nil:
    section.add "$.xgafv", valid_579168
  var valid_579169 = query.getOrDefault("bearer_token")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "bearer_token", valid_579169
  var valid_579170 = query.getOrDefault("alt")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = newJString("json"))
  if valid_579170 != nil:
    section.add "alt", valid_579170
  var valid_579171 = query.getOrDefault("uploadType")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "uploadType", valid_579171
  var valid_579172 = query.getOrDefault("parent")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "parent", valid_579172
  var valid_579173 = query.getOrDefault("quotaUser")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "quotaUser", valid_579173
  var valid_579174 = query.getOrDefault("callback")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "callback", valid_579174
  var valid_579175 = query.getOrDefault("fields")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "fields", valid_579175
  var valid_579176 = query.getOrDefault("access_token")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "access_token", valid_579176
  var valid_579177 = query.getOrDefault("upload_protocol")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "upload_protocol", valid_579177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579178: Call_ContainerProjectsZonesClustersNodePoolsList_579158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_579178.validator(path, query, header, formData, body)
  let scheme = call_579178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579178.url(scheme.get, call_579178.host, call_579178.base,
                         call_579178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579178, url, valid)

proc call*(call_579179: Call_ContainerProjectsZonesClustersNodePoolsList_579158;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579180 = newJObject()
  var query_579181 = newJObject()
  add(query_579181, "key", newJString(key))
  add(query_579181, "pp", newJBool(pp))
  add(query_579181, "prettyPrint", newJBool(prettyPrint))
  add(query_579181, "oauth_token", newJString(oauthToken))
  add(path_579180, "projectId", newJString(projectId))
  add(query_579181, "$.xgafv", newJString(Xgafv))
  add(query_579181, "bearer_token", newJString(bearerToken))
  add(query_579181, "alt", newJString(alt))
  add(query_579181, "uploadType", newJString(uploadType))
  add(query_579181, "parent", newJString(parent))
  add(query_579181, "quotaUser", newJString(quotaUser))
  add(path_579180, "clusterId", newJString(clusterId))
  add(path_579180, "zone", newJString(zone))
  add(query_579181, "callback", newJString(callback))
  add(query_579181, "fields", newJString(fields))
  add(query_579181, "access_token", newJString(accessToken))
  add(query_579181, "upload_protocol", newJString(uploadProtocol))
  result = call_579179.call(path_579180, query_579181, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsList* = Call_ContainerProjectsZonesClustersNodePoolsList_579158(
    name: "containerProjectsZonesClustersNodePoolsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsList_579159,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsList_579160,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsGet_579207 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsGet_579209(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsGet_579208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the node pool requested.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579210 = path.getOrDefault("projectId")
  valid_579210 = validateParameter(valid_579210, JString, required = true,
                                 default = nil)
  if valid_579210 != nil:
    section.add "projectId", valid_579210
  var valid_579211 = path.getOrDefault("clusterId")
  valid_579211 = validateParameter(valid_579211, JString, required = true,
                                 default = nil)
  if valid_579211 != nil:
    section.add "clusterId", valid_579211
  var valid_579212 = path.getOrDefault("nodePoolId")
  valid_579212 = validateParameter(valid_579212, JString, required = true,
                                 default = nil)
  if valid_579212 != nil:
    section.add "nodePoolId", valid_579212
  var valid_579213 = path.getOrDefault("zone")
  valid_579213 = validateParameter(valid_579213, JString, required = true,
                                 default = nil)
  if valid_579213 != nil:
    section.add "zone", valid_579213
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579214 = query.getOrDefault("key")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "key", valid_579214
  var valid_579215 = query.getOrDefault("pp")
  valid_579215 = validateParameter(valid_579215, JBool, required = false,
                                 default = newJBool(true))
  if valid_579215 != nil:
    section.add "pp", valid_579215
  var valid_579216 = query.getOrDefault("prettyPrint")
  valid_579216 = validateParameter(valid_579216, JBool, required = false,
                                 default = newJBool(true))
  if valid_579216 != nil:
    section.add "prettyPrint", valid_579216
  var valid_579217 = query.getOrDefault("oauth_token")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "oauth_token", valid_579217
  var valid_579218 = query.getOrDefault("name")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "name", valid_579218
  var valid_579219 = query.getOrDefault("$.xgafv")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = newJString("1"))
  if valid_579219 != nil:
    section.add "$.xgafv", valid_579219
  var valid_579220 = query.getOrDefault("bearer_token")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "bearer_token", valid_579220
  var valid_579221 = query.getOrDefault("alt")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = newJString("json"))
  if valid_579221 != nil:
    section.add "alt", valid_579221
  var valid_579222 = query.getOrDefault("uploadType")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "uploadType", valid_579222
  var valid_579223 = query.getOrDefault("quotaUser")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "quotaUser", valid_579223
  var valid_579224 = query.getOrDefault("callback")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "callback", valid_579224
  var valid_579225 = query.getOrDefault("fields")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "fields", valid_579225
  var valid_579226 = query.getOrDefault("access_token")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "access_token", valid_579226
  var valid_579227 = query.getOrDefault("upload_protocol")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "upload_protocol", valid_579227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579228: Call_ContainerProjectsZonesClustersNodePoolsGet_579207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the node pool requested.
  ## 
  let valid = call_579228.validator(path, query, header, formData, body)
  let scheme = call_579228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579228.url(scheme.get, call_579228.host, call_579228.base,
                         call_579228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579228, url, valid)

proc call*(call_579229: Call_ContainerProjectsZonesClustersNodePoolsGet_579207;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsGet
  ## Retrieves the node pool requested.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: string (required)
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579230 = newJObject()
  var query_579231 = newJObject()
  add(query_579231, "key", newJString(key))
  add(query_579231, "pp", newJBool(pp))
  add(query_579231, "prettyPrint", newJBool(prettyPrint))
  add(query_579231, "oauth_token", newJString(oauthToken))
  add(query_579231, "name", newJString(name))
  add(path_579230, "projectId", newJString(projectId))
  add(query_579231, "$.xgafv", newJString(Xgafv))
  add(query_579231, "bearer_token", newJString(bearerToken))
  add(query_579231, "alt", newJString(alt))
  add(query_579231, "uploadType", newJString(uploadType))
  add(query_579231, "quotaUser", newJString(quotaUser))
  add(path_579230, "clusterId", newJString(clusterId))
  add(path_579230, "nodePoolId", newJString(nodePoolId))
  add(path_579230, "zone", newJString(zone))
  add(query_579231, "callback", newJString(callback))
  add(query_579231, "fields", newJString(fields))
  add(query_579231, "access_token", newJString(accessToken))
  add(query_579231, "upload_protocol", newJString(uploadProtocol))
  result = call_579229.call(path_579230, query_579231, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsGet* = Call_ContainerProjectsZonesClustersNodePoolsGet_579207(
    name: "containerProjectsZonesClustersNodePoolsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsGet_579208,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsGet_579209,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsDelete_579232 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsDelete_579234(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsDelete_579233(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a node pool from a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579235 = path.getOrDefault("projectId")
  valid_579235 = validateParameter(valid_579235, JString, required = true,
                                 default = nil)
  if valid_579235 != nil:
    section.add "projectId", valid_579235
  var valid_579236 = path.getOrDefault("clusterId")
  valid_579236 = validateParameter(valid_579236, JString, required = true,
                                 default = nil)
  if valid_579236 != nil:
    section.add "clusterId", valid_579236
  var valid_579237 = path.getOrDefault("nodePoolId")
  valid_579237 = validateParameter(valid_579237, JString, required = true,
                                 default = nil)
  if valid_579237 != nil:
    section.add "nodePoolId", valid_579237
  var valid_579238 = path.getOrDefault("zone")
  valid_579238 = validateParameter(valid_579238, JString, required = true,
                                 default = nil)
  if valid_579238 != nil:
    section.add "zone", valid_579238
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579239 = query.getOrDefault("key")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "key", valid_579239
  var valid_579240 = query.getOrDefault("pp")
  valid_579240 = validateParameter(valid_579240, JBool, required = false,
                                 default = newJBool(true))
  if valid_579240 != nil:
    section.add "pp", valid_579240
  var valid_579241 = query.getOrDefault("prettyPrint")
  valid_579241 = validateParameter(valid_579241, JBool, required = false,
                                 default = newJBool(true))
  if valid_579241 != nil:
    section.add "prettyPrint", valid_579241
  var valid_579242 = query.getOrDefault("oauth_token")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "oauth_token", valid_579242
  var valid_579243 = query.getOrDefault("name")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "name", valid_579243
  var valid_579244 = query.getOrDefault("$.xgafv")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = newJString("1"))
  if valid_579244 != nil:
    section.add "$.xgafv", valid_579244
  var valid_579245 = query.getOrDefault("bearer_token")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "bearer_token", valid_579245
  var valid_579246 = query.getOrDefault("alt")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = newJString("json"))
  if valid_579246 != nil:
    section.add "alt", valid_579246
  var valid_579247 = query.getOrDefault("uploadType")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "uploadType", valid_579247
  var valid_579248 = query.getOrDefault("quotaUser")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "quotaUser", valid_579248
  var valid_579249 = query.getOrDefault("callback")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "callback", valid_579249
  var valid_579250 = query.getOrDefault("fields")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "fields", valid_579250
  var valid_579251 = query.getOrDefault("access_token")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "access_token", valid_579251
  var valid_579252 = query.getOrDefault("upload_protocol")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "upload_protocol", valid_579252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579253: Call_ContainerProjectsZonesClustersNodePoolsDelete_579232;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_579253.validator(path, query, header, formData, body)
  let scheme = call_579253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579253.url(scheme.get, call_579253.host, call_579253.base,
                         call_579253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579253, url, valid)

proc call*(call_579254: Call_ContainerProjectsZonesClustersNodePoolsDelete_579232;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579255 = newJObject()
  var query_579256 = newJObject()
  add(query_579256, "key", newJString(key))
  add(query_579256, "pp", newJBool(pp))
  add(query_579256, "prettyPrint", newJBool(prettyPrint))
  add(query_579256, "oauth_token", newJString(oauthToken))
  add(query_579256, "name", newJString(name))
  add(path_579255, "projectId", newJString(projectId))
  add(query_579256, "$.xgafv", newJString(Xgafv))
  add(query_579256, "bearer_token", newJString(bearerToken))
  add(query_579256, "alt", newJString(alt))
  add(query_579256, "uploadType", newJString(uploadType))
  add(query_579256, "quotaUser", newJString(quotaUser))
  add(path_579255, "clusterId", newJString(clusterId))
  add(path_579255, "nodePoolId", newJString(nodePoolId))
  add(path_579255, "zone", newJString(zone))
  add(query_579256, "callback", newJString(callback))
  add(query_579256, "fields", newJString(fields))
  add(query_579256, "access_token", newJString(accessToken))
  add(query_579256, "upload_protocol", newJString(uploadProtocol))
  result = call_579254.call(path_579255, query_579256, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsDelete* = Call_ContainerProjectsZonesClustersNodePoolsDelete_579232(
    name: "containerProjectsZonesClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsDelete_579233,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsDelete_579234,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_579257 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsAutoscaling_579259(
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

proc validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_579258(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579260 = path.getOrDefault("projectId")
  valid_579260 = validateParameter(valid_579260, JString, required = true,
                                 default = nil)
  if valid_579260 != nil:
    section.add "projectId", valid_579260
  var valid_579261 = path.getOrDefault("clusterId")
  valid_579261 = validateParameter(valid_579261, JString, required = true,
                                 default = nil)
  if valid_579261 != nil:
    section.add "clusterId", valid_579261
  var valid_579262 = path.getOrDefault("nodePoolId")
  valid_579262 = validateParameter(valid_579262, JString, required = true,
                                 default = nil)
  if valid_579262 != nil:
    section.add "nodePoolId", valid_579262
  var valid_579263 = path.getOrDefault("zone")
  valid_579263 = validateParameter(valid_579263, JString, required = true,
                                 default = nil)
  if valid_579263 != nil:
    section.add "zone", valid_579263
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579264 = query.getOrDefault("key")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "key", valid_579264
  var valid_579265 = query.getOrDefault("pp")
  valid_579265 = validateParameter(valid_579265, JBool, required = false,
                                 default = newJBool(true))
  if valid_579265 != nil:
    section.add "pp", valid_579265
  var valid_579266 = query.getOrDefault("prettyPrint")
  valid_579266 = validateParameter(valid_579266, JBool, required = false,
                                 default = newJBool(true))
  if valid_579266 != nil:
    section.add "prettyPrint", valid_579266
  var valid_579267 = query.getOrDefault("oauth_token")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "oauth_token", valid_579267
  var valid_579268 = query.getOrDefault("$.xgafv")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = newJString("1"))
  if valid_579268 != nil:
    section.add "$.xgafv", valid_579268
  var valid_579269 = query.getOrDefault("bearer_token")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "bearer_token", valid_579269
  var valid_579270 = query.getOrDefault("alt")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = newJString("json"))
  if valid_579270 != nil:
    section.add "alt", valid_579270
  var valid_579271 = query.getOrDefault("uploadType")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "uploadType", valid_579271
  var valid_579272 = query.getOrDefault("quotaUser")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "quotaUser", valid_579272
  var valid_579273 = query.getOrDefault("callback")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "callback", valid_579273
  var valid_579274 = query.getOrDefault("fields")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "fields", valid_579274
  var valid_579275 = query.getOrDefault("access_token")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "access_token", valid_579275
  var valid_579276 = query.getOrDefault("upload_protocol")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "upload_protocol", valid_579276
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

proc call*(call_579278: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_579257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  let valid = call_579278.validator(path, query, header, formData, body)
  let scheme = call_579278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579278.url(scheme.get, call_579278.host, call_579278.base,
                         call_579278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579278, url, valid)

proc call*(call_579279: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_579257;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsAutoscaling
  ## Sets the autoscaling settings of a specific node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579280 = newJObject()
  var query_579281 = newJObject()
  var body_579282 = newJObject()
  add(query_579281, "key", newJString(key))
  add(query_579281, "pp", newJBool(pp))
  add(query_579281, "prettyPrint", newJBool(prettyPrint))
  add(query_579281, "oauth_token", newJString(oauthToken))
  add(path_579280, "projectId", newJString(projectId))
  add(query_579281, "$.xgafv", newJString(Xgafv))
  add(query_579281, "bearer_token", newJString(bearerToken))
  add(query_579281, "alt", newJString(alt))
  add(query_579281, "uploadType", newJString(uploadType))
  add(query_579281, "quotaUser", newJString(quotaUser))
  add(path_579280, "clusterId", newJString(clusterId))
  add(path_579280, "nodePoolId", newJString(nodePoolId))
  add(path_579280, "zone", newJString(zone))
  if body != nil:
    body_579282 = body
  add(query_579281, "callback", newJString(callback))
  add(query_579281, "fields", newJString(fields))
  add(query_579281, "access_token", newJString(accessToken))
  add(query_579281, "upload_protocol", newJString(uploadProtocol))
  result = call_579279.call(path_579280, query_579281, nil, nil, body_579282)

var containerProjectsZonesClustersNodePoolsAutoscaling* = Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_579257(
    name: "containerProjectsZonesClustersNodePoolsAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/autoscaling",
    validator: validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_579258,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsAutoscaling_579259,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetManagement_579283 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsSetManagement_579285(
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

proc validate_ContainerProjectsZonesClustersNodePoolsSetManagement_579284(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the NodeManagement options for a node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to update.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579286 = path.getOrDefault("projectId")
  valid_579286 = validateParameter(valid_579286, JString, required = true,
                                 default = nil)
  if valid_579286 != nil:
    section.add "projectId", valid_579286
  var valid_579287 = path.getOrDefault("clusterId")
  valid_579287 = validateParameter(valid_579287, JString, required = true,
                                 default = nil)
  if valid_579287 != nil:
    section.add "clusterId", valid_579287
  var valid_579288 = path.getOrDefault("nodePoolId")
  valid_579288 = validateParameter(valid_579288, JString, required = true,
                                 default = nil)
  if valid_579288 != nil:
    section.add "nodePoolId", valid_579288
  var valid_579289 = path.getOrDefault("zone")
  valid_579289 = validateParameter(valid_579289, JString, required = true,
                                 default = nil)
  if valid_579289 != nil:
    section.add "zone", valid_579289
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579290 = query.getOrDefault("key")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "key", valid_579290
  var valid_579291 = query.getOrDefault("pp")
  valid_579291 = validateParameter(valid_579291, JBool, required = false,
                                 default = newJBool(true))
  if valid_579291 != nil:
    section.add "pp", valid_579291
  var valid_579292 = query.getOrDefault("prettyPrint")
  valid_579292 = validateParameter(valid_579292, JBool, required = false,
                                 default = newJBool(true))
  if valid_579292 != nil:
    section.add "prettyPrint", valid_579292
  var valid_579293 = query.getOrDefault("oauth_token")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "oauth_token", valid_579293
  var valid_579294 = query.getOrDefault("$.xgafv")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = newJString("1"))
  if valid_579294 != nil:
    section.add "$.xgafv", valid_579294
  var valid_579295 = query.getOrDefault("bearer_token")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "bearer_token", valid_579295
  var valid_579296 = query.getOrDefault("alt")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = newJString("json"))
  if valid_579296 != nil:
    section.add "alt", valid_579296
  var valid_579297 = query.getOrDefault("uploadType")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "uploadType", valid_579297
  var valid_579298 = query.getOrDefault("quotaUser")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "quotaUser", valid_579298
  var valid_579299 = query.getOrDefault("callback")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "callback", valid_579299
  var valid_579300 = query.getOrDefault("fields")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "fields", valid_579300
  var valid_579301 = query.getOrDefault("access_token")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "access_token", valid_579301
  var valid_579302 = query.getOrDefault("upload_protocol")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "upload_protocol", valid_579302
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

proc call*(call_579304: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_579283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_579304.validator(path, query, header, formData, body)
  let scheme = call_579304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579304.url(scheme.get, call_579304.host, call_579304.base,
                         call_579304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579304, url, valid)

proc call*(call_579305: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_579283;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to update.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to update.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579306 = newJObject()
  var query_579307 = newJObject()
  var body_579308 = newJObject()
  add(query_579307, "key", newJString(key))
  add(query_579307, "pp", newJBool(pp))
  add(query_579307, "prettyPrint", newJBool(prettyPrint))
  add(query_579307, "oauth_token", newJString(oauthToken))
  add(path_579306, "projectId", newJString(projectId))
  add(query_579307, "$.xgafv", newJString(Xgafv))
  add(query_579307, "bearer_token", newJString(bearerToken))
  add(query_579307, "alt", newJString(alt))
  add(query_579307, "uploadType", newJString(uploadType))
  add(query_579307, "quotaUser", newJString(quotaUser))
  add(path_579306, "clusterId", newJString(clusterId))
  add(path_579306, "nodePoolId", newJString(nodePoolId))
  add(path_579306, "zone", newJString(zone))
  if body != nil:
    body_579308 = body
  add(query_579307, "callback", newJString(callback))
  add(query_579307, "fields", newJString(fields))
  add(query_579307, "access_token", newJString(accessToken))
  add(query_579307, "upload_protocol", newJString(uploadProtocol))
  result = call_579305.call(path_579306, query_579307, nil, nil, body_579308)

var containerProjectsZonesClustersNodePoolsSetManagement* = Call_ContainerProjectsZonesClustersNodePoolsSetManagement_579283(
    name: "containerProjectsZonesClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setManagement",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetManagement_579284,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetManagement_579285,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsUpdate_579309 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsUpdate_579311(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsUpdate_579310(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579312 = path.getOrDefault("projectId")
  valid_579312 = validateParameter(valid_579312, JString, required = true,
                                 default = nil)
  if valid_579312 != nil:
    section.add "projectId", valid_579312
  var valid_579313 = path.getOrDefault("clusterId")
  valid_579313 = validateParameter(valid_579313, JString, required = true,
                                 default = nil)
  if valid_579313 != nil:
    section.add "clusterId", valid_579313
  var valid_579314 = path.getOrDefault("nodePoolId")
  valid_579314 = validateParameter(valid_579314, JString, required = true,
                                 default = nil)
  if valid_579314 != nil:
    section.add "nodePoolId", valid_579314
  var valid_579315 = path.getOrDefault("zone")
  valid_579315 = validateParameter(valid_579315, JString, required = true,
                                 default = nil)
  if valid_579315 != nil:
    section.add "zone", valid_579315
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579316 = query.getOrDefault("key")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "key", valid_579316
  var valid_579317 = query.getOrDefault("pp")
  valid_579317 = validateParameter(valid_579317, JBool, required = false,
                                 default = newJBool(true))
  if valid_579317 != nil:
    section.add "pp", valid_579317
  var valid_579318 = query.getOrDefault("prettyPrint")
  valid_579318 = validateParameter(valid_579318, JBool, required = false,
                                 default = newJBool(true))
  if valid_579318 != nil:
    section.add "prettyPrint", valid_579318
  var valid_579319 = query.getOrDefault("oauth_token")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "oauth_token", valid_579319
  var valid_579320 = query.getOrDefault("$.xgafv")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("1"))
  if valid_579320 != nil:
    section.add "$.xgafv", valid_579320
  var valid_579321 = query.getOrDefault("bearer_token")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "bearer_token", valid_579321
  var valid_579322 = query.getOrDefault("alt")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = newJString("json"))
  if valid_579322 != nil:
    section.add "alt", valid_579322
  var valid_579323 = query.getOrDefault("uploadType")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "uploadType", valid_579323
  var valid_579324 = query.getOrDefault("quotaUser")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "quotaUser", valid_579324
  var valid_579325 = query.getOrDefault("callback")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "callback", valid_579325
  var valid_579326 = query.getOrDefault("fields")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "fields", valid_579326
  var valid_579327 = query.getOrDefault("access_token")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "access_token", valid_579327
  var valid_579328 = query.getOrDefault("upload_protocol")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "upload_protocol", valid_579328
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

proc call*(call_579330: Call_ContainerProjectsZonesClustersNodePoolsUpdate_579309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  let valid = call_579330.validator(path, query, header, formData, body)
  let scheme = call_579330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579330.url(scheme.get, call_579330.host, call_579330.base,
                         call_579330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579330, url, valid)

proc call*(call_579331: Call_ContainerProjectsZonesClustersNodePoolsUpdate_579309;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsUpdate
  ## Updates the version and/or iamge type of a specific node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579332 = newJObject()
  var query_579333 = newJObject()
  var body_579334 = newJObject()
  add(query_579333, "key", newJString(key))
  add(query_579333, "pp", newJBool(pp))
  add(query_579333, "prettyPrint", newJBool(prettyPrint))
  add(query_579333, "oauth_token", newJString(oauthToken))
  add(path_579332, "projectId", newJString(projectId))
  add(query_579333, "$.xgafv", newJString(Xgafv))
  add(query_579333, "bearer_token", newJString(bearerToken))
  add(query_579333, "alt", newJString(alt))
  add(query_579333, "uploadType", newJString(uploadType))
  add(query_579333, "quotaUser", newJString(quotaUser))
  add(path_579332, "clusterId", newJString(clusterId))
  add(path_579332, "nodePoolId", newJString(nodePoolId))
  add(path_579332, "zone", newJString(zone))
  if body != nil:
    body_579334 = body
  add(query_579333, "callback", newJString(callback))
  add(query_579333, "fields", newJString(fields))
  add(query_579333, "access_token", newJString(accessToken))
  add(query_579333, "upload_protocol", newJString(uploadProtocol))
  result = call_579331.call(path_579332, query_579333, nil, nil, body_579334)

var containerProjectsZonesClustersNodePoolsUpdate* = Call_ContainerProjectsZonesClustersNodePoolsUpdate_579309(
    name: "containerProjectsZonesClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/update",
    validator: validate_ContainerProjectsZonesClustersNodePoolsUpdate_579310,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsUpdate_579311,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsRollback_579335 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersNodePoolsRollback_579337(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsRollback_579336(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to rollback.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: JString (required)
  ##             : The name of the node pool to rollback.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579338 = path.getOrDefault("projectId")
  valid_579338 = validateParameter(valid_579338, JString, required = true,
                                 default = nil)
  if valid_579338 != nil:
    section.add "projectId", valid_579338
  var valid_579339 = path.getOrDefault("clusterId")
  valid_579339 = validateParameter(valid_579339, JString, required = true,
                                 default = nil)
  if valid_579339 != nil:
    section.add "clusterId", valid_579339
  var valid_579340 = path.getOrDefault("nodePoolId")
  valid_579340 = validateParameter(valid_579340, JString, required = true,
                                 default = nil)
  if valid_579340 != nil:
    section.add "nodePoolId", valid_579340
  var valid_579341 = path.getOrDefault("zone")
  valid_579341 = validateParameter(valid_579341, JString, required = true,
                                 default = nil)
  if valid_579341 != nil:
    section.add "zone", valid_579341
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579342 = query.getOrDefault("key")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "key", valid_579342
  var valid_579343 = query.getOrDefault("pp")
  valid_579343 = validateParameter(valid_579343, JBool, required = false,
                                 default = newJBool(true))
  if valid_579343 != nil:
    section.add "pp", valid_579343
  var valid_579344 = query.getOrDefault("prettyPrint")
  valid_579344 = validateParameter(valid_579344, JBool, required = false,
                                 default = newJBool(true))
  if valid_579344 != nil:
    section.add "prettyPrint", valid_579344
  var valid_579345 = query.getOrDefault("oauth_token")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "oauth_token", valid_579345
  var valid_579346 = query.getOrDefault("$.xgafv")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = newJString("1"))
  if valid_579346 != nil:
    section.add "$.xgafv", valid_579346
  var valid_579347 = query.getOrDefault("bearer_token")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "bearer_token", valid_579347
  var valid_579348 = query.getOrDefault("alt")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = newJString("json"))
  if valid_579348 != nil:
    section.add "alt", valid_579348
  var valid_579349 = query.getOrDefault("uploadType")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "uploadType", valid_579349
  var valid_579350 = query.getOrDefault("quotaUser")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "quotaUser", valid_579350
  var valid_579351 = query.getOrDefault("callback")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "callback", valid_579351
  var valid_579352 = query.getOrDefault("fields")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "fields", valid_579352
  var valid_579353 = query.getOrDefault("access_token")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "access_token", valid_579353
  var valid_579354 = query.getOrDefault("upload_protocol")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "upload_protocol", valid_579354
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

proc call*(call_579356: Call_ContainerProjectsZonesClustersNodePoolsRollback_579335;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  let valid = call_579356.validator(path, query, header, formData, body)
  let scheme = call_579356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579356.url(scheme.get, call_579356.host, call_579356.base,
                         call_579356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579356, url, valid)

proc call*(call_579357: Call_ContainerProjectsZonesClustersNodePoolsRollback_579335;
          projectId: string; clusterId: string; nodePoolId: string; zone: string;
          key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersNodePoolsRollback
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to rollback.
  ## This field is deprecated, use name instead.
  ##   nodePoolId: string (required)
  ##             : The name of the node pool to rollback.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579358 = newJObject()
  var query_579359 = newJObject()
  var body_579360 = newJObject()
  add(query_579359, "key", newJString(key))
  add(query_579359, "pp", newJBool(pp))
  add(query_579359, "prettyPrint", newJBool(prettyPrint))
  add(query_579359, "oauth_token", newJString(oauthToken))
  add(path_579358, "projectId", newJString(projectId))
  add(query_579359, "$.xgafv", newJString(Xgafv))
  add(query_579359, "bearer_token", newJString(bearerToken))
  add(query_579359, "alt", newJString(alt))
  add(query_579359, "uploadType", newJString(uploadType))
  add(query_579359, "quotaUser", newJString(quotaUser))
  add(path_579358, "clusterId", newJString(clusterId))
  add(path_579358, "nodePoolId", newJString(nodePoolId))
  add(path_579358, "zone", newJString(zone))
  if body != nil:
    body_579360 = body
  add(query_579359, "callback", newJString(callback))
  add(query_579359, "fields", newJString(fields))
  add(query_579359, "access_token", newJString(accessToken))
  add(query_579359, "upload_protocol", newJString(uploadProtocol))
  result = call_579357.call(path_579358, query_579359, nil, nil, body_579360)

var containerProjectsZonesClustersNodePoolsRollback* = Call_ContainerProjectsZonesClustersNodePoolsRollback_579335(
    name: "containerProjectsZonesClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}:rollback",
    validator: validate_ContainerProjectsZonesClustersNodePoolsRollback_579336,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsRollback_579337,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersResourceLabels_579361 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersResourceLabels_579363(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersResourceLabels_579362(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets labels on a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579364 = path.getOrDefault("projectId")
  valid_579364 = validateParameter(valid_579364, JString, required = true,
                                 default = nil)
  if valid_579364 != nil:
    section.add "projectId", valid_579364
  var valid_579365 = path.getOrDefault("clusterId")
  valid_579365 = validateParameter(valid_579365, JString, required = true,
                                 default = nil)
  if valid_579365 != nil:
    section.add "clusterId", valid_579365
  var valid_579366 = path.getOrDefault("zone")
  valid_579366 = validateParameter(valid_579366, JString, required = true,
                                 default = nil)
  if valid_579366 != nil:
    section.add "zone", valid_579366
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579367 = query.getOrDefault("key")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "key", valid_579367
  var valid_579368 = query.getOrDefault("pp")
  valid_579368 = validateParameter(valid_579368, JBool, required = false,
                                 default = newJBool(true))
  if valid_579368 != nil:
    section.add "pp", valid_579368
  var valid_579369 = query.getOrDefault("prettyPrint")
  valid_579369 = validateParameter(valid_579369, JBool, required = false,
                                 default = newJBool(true))
  if valid_579369 != nil:
    section.add "prettyPrint", valid_579369
  var valid_579370 = query.getOrDefault("oauth_token")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "oauth_token", valid_579370
  var valid_579371 = query.getOrDefault("$.xgafv")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = newJString("1"))
  if valid_579371 != nil:
    section.add "$.xgafv", valid_579371
  var valid_579372 = query.getOrDefault("bearer_token")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "bearer_token", valid_579372
  var valid_579373 = query.getOrDefault("alt")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = newJString("json"))
  if valid_579373 != nil:
    section.add "alt", valid_579373
  var valid_579374 = query.getOrDefault("uploadType")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "uploadType", valid_579374
  var valid_579375 = query.getOrDefault("quotaUser")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "quotaUser", valid_579375
  var valid_579376 = query.getOrDefault("callback")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "callback", valid_579376
  var valid_579377 = query.getOrDefault("fields")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "fields", valid_579377
  var valid_579378 = query.getOrDefault("access_token")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "access_token", valid_579378
  var valid_579379 = query.getOrDefault("upload_protocol")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "upload_protocol", valid_579379
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

proc call*(call_579381: Call_ContainerProjectsZonesClustersResourceLabels_579361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_579381.validator(path, query, header, formData, body)
  let scheme = call_579381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579381.url(scheme.get, call_579381.host, call_579381.base,
                         call_579381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579381, url, valid)

proc call*(call_579382: Call_ContainerProjectsZonesClustersResourceLabels_579361;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersResourceLabels
  ## Sets labels on a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579383 = newJObject()
  var query_579384 = newJObject()
  var body_579385 = newJObject()
  add(query_579384, "key", newJString(key))
  add(query_579384, "pp", newJBool(pp))
  add(query_579384, "prettyPrint", newJBool(prettyPrint))
  add(query_579384, "oauth_token", newJString(oauthToken))
  add(path_579383, "projectId", newJString(projectId))
  add(query_579384, "$.xgafv", newJString(Xgafv))
  add(query_579384, "bearer_token", newJString(bearerToken))
  add(query_579384, "alt", newJString(alt))
  add(query_579384, "uploadType", newJString(uploadType))
  add(query_579384, "quotaUser", newJString(quotaUser))
  add(path_579383, "clusterId", newJString(clusterId))
  add(path_579383, "zone", newJString(zone))
  if body != nil:
    body_579385 = body
  add(query_579384, "callback", newJString(callback))
  add(query_579384, "fields", newJString(fields))
  add(query_579384, "access_token", newJString(accessToken))
  add(query_579384, "upload_protocol", newJString(uploadProtocol))
  result = call_579382.call(path_579383, query_579384, nil, nil, body_579385)

var containerProjectsZonesClustersResourceLabels* = Call_ContainerProjectsZonesClustersResourceLabels_579361(
    name: "containerProjectsZonesClustersResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/resourceLabels",
    validator: validate_ContainerProjectsZonesClustersResourceLabels_579362,
    base: "/", url: url_ContainerProjectsZonesClustersResourceLabels_579363,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersCompleteIpRotation_579386 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersCompleteIpRotation_579388(
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

proc validate_ContainerProjectsZonesClustersCompleteIpRotation_579387(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Completes master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579389 = path.getOrDefault("projectId")
  valid_579389 = validateParameter(valid_579389, JString, required = true,
                                 default = nil)
  if valid_579389 != nil:
    section.add "projectId", valid_579389
  var valid_579390 = path.getOrDefault("clusterId")
  valid_579390 = validateParameter(valid_579390, JString, required = true,
                                 default = nil)
  if valid_579390 != nil:
    section.add "clusterId", valid_579390
  var valid_579391 = path.getOrDefault("zone")
  valid_579391 = validateParameter(valid_579391, JString, required = true,
                                 default = nil)
  if valid_579391 != nil:
    section.add "zone", valid_579391
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579392 = query.getOrDefault("key")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "key", valid_579392
  var valid_579393 = query.getOrDefault("pp")
  valid_579393 = validateParameter(valid_579393, JBool, required = false,
                                 default = newJBool(true))
  if valid_579393 != nil:
    section.add "pp", valid_579393
  var valid_579394 = query.getOrDefault("prettyPrint")
  valid_579394 = validateParameter(valid_579394, JBool, required = false,
                                 default = newJBool(true))
  if valid_579394 != nil:
    section.add "prettyPrint", valid_579394
  var valid_579395 = query.getOrDefault("oauth_token")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "oauth_token", valid_579395
  var valid_579396 = query.getOrDefault("$.xgafv")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = newJString("1"))
  if valid_579396 != nil:
    section.add "$.xgafv", valid_579396
  var valid_579397 = query.getOrDefault("bearer_token")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "bearer_token", valid_579397
  var valid_579398 = query.getOrDefault("alt")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = newJString("json"))
  if valid_579398 != nil:
    section.add "alt", valid_579398
  var valid_579399 = query.getOrDefault("uploadType")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "uploadType", valid_579399
  var valid_579400 = query.getOrDefault("quotaUser")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "quotaUser", valid_579400
  var valid_579401 = query.getOrDefault("callback")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "callback", valid_579401
  var valid_579402 = query.getOrDefault("fields")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "fields", valid_579402
  var valid_579403 = query.getOrDefault("access_token")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "access_token", valid_579403
  var valid_579404 = query.getOrDefault("upload_protocol")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "upload_protocol", valid_579404
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

proc call*(call_579406: Call_ContainerProjectsZonesClustersCompleteIpRotation_579386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_579406.validator(path, query, header, formData, body)
  let scheme = call_579406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579406.url(scheme.get, call_579406.host, call_579406.base,
                         call_579406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579406, url, valid)

proc call*(call_579407: Call_ContainerProjectsZonesClustersCompleteIpRotation_579386;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579408 = newJObject()
  var query_579409 = newJObject()
  var body_579410 = newJObject()
  add(query_579409, "key", newJString(key))
  add(query_579409, "pp", newJBool(pp))
  add(query_579409, "prettyPrint", newJBool(prettyPrint))
  add(query_579409, "oauth_token", newJString(oauthToken))
  add(path_579408, "projectId", newJString(projectId))
  add(query_579409, "$.xgafv", newJString(Xgafv))
  add(query_579409, "bearer_token", newJString(bearerToken))
  add(query_579409, "alt", newJString(alt))
  add(query_579409, "uploadType", newJString(uploadType))
  add(query_579409, "quotaUser", newJString(quotaUser))
  add(path_579408, "clusterId", newJString(clusterId))
  add(path_579408, "zone", newJString(zone))
  if body != nil:
    body_579410 = body
  add(query_579409, "callback", newJString(callback))
  add(query_579409, "fields", newJString(fields))
  add(query_579409, "access_token", newJString(accessToken))
  add(query_579409, "upload_protocol", newJString(uploadProtocol))
  result = call_579407.call(path_579408, query_579409, nil, nil, body_579410)

var containerProjectsZonesClustersCompleteIpRotation* = Call_ContainerProjectsZonesClustersCompleteIpRotation_579386(
    name: "containerProjectsZonesClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:completeIpRotation",
    validator: validate_ContainerProjectsZonesClustersCompleteIpRotation_579387,
    base: "/", url: url_ContainerProjectsZonesClustersCompleteIpRotation_579388,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMaintenancePolicy_579411 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersSetMaintenancePolicy_579413(
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

proc validate_ContainerProjectsZonesClustersSetMaintenancePolicy_579412(
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
  var valid_579414 = path.getOrDefault("projectId")
  valid_579414 = validateParameter(valid_579414, JString, required = true,
                                 default = nil)
  if valid_579414 != nil:
    section.add "projectId", valid_579414
  var valid_579415 = path.getOrDefault("clusterId")
  valid_579415 = validateParameter(valid_579415, JString, required = true,
                                 default = nil)
  if valid_579415 != nil:
    section.add "clusterId", valid_579415
  var valid_579416 = path.getOrDefault("zone")
  valid_579416 = validateParameter(valid_579416, JString, required = true,
                                 default = nil)
  if valid_579416 != nil:
    section.add "zone", valid_579416
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579417 = query.getOrDefault("key")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "key", valid_579417
  var valid_579418 = query.getOrDefault("pp")
  valid_579418 = validateParameter(valid_579418, JBool, required = false,
                                 default = newJBool(true))
  if valid_579418 != nil:
    section.add "pp", valid_579418
  var valid_579419 = query.getOrDefault("prettyPrint")
  valid_579419 = validateParameter(valid_579419, JBool, required = false,
                                 default = newJBool(true))
  if valid_579419 != nil:
    section.add "prettyPrint", valid_579419
  var valid_579420 = query.getOrDefault("oauth_token")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "oauth_token", valid_579420
  var valid_579421 = query.getOrDefault("$.xgafv")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = newJString("1"))
  if valid_579421 != nil:
    section.add "$.xgafv", valid_579421
  var valid_579422 = query.getOrDefault("bearer_token")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "bearer_token", valid_579422
  var valid_579423 = query.getOrDefault("alt")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = newJString("json"))
  if valid_579423 != nil:
    section.add "alt", valid_579423
  var valid_579424 = query.getOrDefault("uploadType")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "uploadType", valid_579424
  var valid_579425 = query.getOrDefault("quotaUser")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "quotaUser", valid_579425
  var valid_579426 = query.getOrDefault("callback")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "callback", valid_579426
  var valid_579427 = query.getOrDefault("fields")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "fields", valid_579427
  var valid_579428 = query.getOrDefault("access_token")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "access_token", valid_579428
  var valid_579429 = query.getOrDefault("upload_protocol")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "upload_protocol", valid_579429
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

proc call*(call_579431: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_579411;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_579431.validator(path, query, header, formData, body)
  let scheme = call_579431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579431.url(scheme.get, call_579431.host, call_579431.base,
                         call_579431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579431, url, valid)

proc call*(call_579432: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_579411;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersSetMaintenancePolicy
  ## Sets the maintenance policy for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579433 = newJObject()
  var query_579434 = newJObject()
  var body_579435 = newJObject()
  add(query_579434, "key", newJString(key))
  add(query_579434, "pp", newJBool(pp))
  add(query_579434, "prettyPrint", newJBool(prettyPrint))
  add(query_579434, "oauth_token", newJString(oauthToken))
  add(path_579433, "projectId", newJString(projectId))
  add(query_579434, "$.xgafv", newJString(Xgafv))
  add(query_579434, "bearer_token", newJString(bearerToken))
  add(query_579434, "alt", newJString(alt))
  add(query_579434, "uploadType", newJString(uploadType))
  add(query_579434, "quotaUser", newJString(quotaUser))
  add(path_579433, "clusterId", newJString(clusterId))
  add(path_579433, "zone", newJString(zone))
  if body != nil:
    body_579435 = body
  add(query_579434, "callback", newJString(callback))
  add(query_579434, "fields", newJString(fields))
  add(query_579434, "access_token", newJString(accessToken))
  add(query_579434, "upload_protocol", newJString(uploadProtocol))
  result = call_579432.call(path_579433, query_579434, nil, nil, body_579435)

var containerProjectsZonesClustersSetMaintenancePolicy* = Call_ContainerProjectsZonesClustersSetMaintenancePolicy_579411(
    name: "containerProjectsZonesClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMaintenancePolicy",
    validator: validate_ContainerProjectsZonesClustersSetMaintenancePolicy_579412,
    base: "/", url: url_ContainerProjectsZonesClustersSetMaintenancePolicy_579413,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMasterAuth_579436 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersSetMasterAuth_579438(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersSetMasterAuth_579437(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579439 = path.getOrDefault("projectId")
  valid_579439 = validateParameter(valid_579439, JString, required = true,
                                 default = nil)
  if valid_579439 != nil:
    section.add "projectId", valid_579439
  var valid_579440 = path.getOrDefault("clusterId")
  valid_579440 = validateParameter(valid_579440, JString, required = true,
                                 default = nil)
  if valid_579440 != nil:
    section.add "clusterId", valid_579440
  var valid_579441 = path.getOrDefault("zone")
  valid_579441 = validateParameter(valid_579441, JString, required = true,
                                 default = nil)
  if valid_579441 != nil:
    section.add "zone", valid_579441
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579442 = query.getOrDefault("key")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "key", valid_579442
  var valid_579443 = query.getOrDefault("pp")
  valid_579443 = validateParameter(valid_579443, JBool, required = false,
                                 default = newJBool(true))
  if valid_579443 != nil:
    section.add "pp", valid_579443
  var valid_579444 = query.getOrDefault("prettyPrint")
  valid_579444 = validateParameter(valid_579444, JBool, required = false,
                                 default = newJBool(true))
  if valid_579444 != nil:
    section.add "prettyPrint", valid_579444
  var valid_579445 = query.getOrDefault("oauth_token")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "oauth_token", valid_579445
  var valid_579446 = query.getOrDefault("$.xgafv")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = newJString("1"))
  if valid_579446 != nil:
    section.add "$.xgafv", valid_579446
  var valid_579447 = query.getOrDefault("bearer_token")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "bearer_token", valid_579447
  var valid_579448 = query.getOrDefault("alt")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = newJString("json"))
  if valid_579448 != nil:
    section.add "alt", valid_579448
  var valid_579449 = query.getOrDefault("uploadType")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "uploadType", valid_579449
  var valid_579450 = query.getOrDefault("quotaUser")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "quotaUser", valid_579450
  var valid_579451 = query.getOrDefault("callback")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "callback", valid_579451
  var valid_579452 = query.getOrDefault("fields")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "fields", valid_579452
  var valid_579453 = query.getOrDefault("access_token")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "access_token", valid_579453
  var valid_579454 = query.getOrDefault("upload_protocol")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "upload_protocol", valid_579454
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

proc call*(call_579456: Call_ContainerProjectsZonesClustersSetMasterAuth_579436;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  let valid = call_579456.validator(path, query, header, formData, body)
  let scheme = call_579456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579456.url(scheme.get, call_579456.host, call_579456.base,
                         call_579456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579456, url, valid)

proc call*(call_579457: Call_ContainerProjectsZonesClustersSetMasterAuth_579436;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersSetMasterAuth
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster to upgrade.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579458 = newJObject()
  var query_579459 = newJObject()
  var body_579460 = newJObject()
  add(query_579459, "key", newJString(key))
  add(query_579459, "pp", newJBool(pp))
  add(query_579459, "prettyPrint", newJBool(prettyPrint))
  add(query_579459, "oauth_token", newJString(oauthToken))
  add(path_579458, "projectId", newJString(projectId))
  add(query_579459, "$.xgafv", newJString(Xgafv))
  add(query_579459, "bearer_token", newJString(bearerToken))
  add(query_579459, "alt", newJString(alt))
  add(query_579459, "uploadType", newJString(uploadType))
  add(query_579459, "quotaUser", newJString(quotaUser))
  add(path_579458, "clusterId", newJString(clusterId))
  add(path_579458, "zone", newJString(zone))
  if body != nil:
    body_579460 = body
  add(query_579459, "callback", newJString(callback))
  add(query_579459, "fields", newJString(fields))
  add(query_579459, "access_token", newJString(accessToken))
  add(query_579459, "upload_protocol", newJString(uploadProtocol))
  result = call_579457.call(path_579458, query_579459, nil, nil, body_579460)

var containerProjectsZonesClustersSetMasterAuth* = Call_ContainerProjectsZonesClustersSetMasterAuth_579436(
    name: "containerProjectsZonesClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMasterAuth",
    validator: validate_ContainerProjectsZonesClustersSetMasterAuth_579437,
    base: "/", url: url_ContainerProjectsZonesClustersSetMasterAuth_579438,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetNetworkPolicy_579461 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersSetNetworkPolicy_579463(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersSetNetworkPolicy_579462(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579464 = path.getOrDefault("projectId")
  valid_579464 = validateParameter(valid_579464, JString, required = true,
                                 default = nil)
  if valid_579464 != nil:
    section.add "projectId", valid_579464
  var valid_579465 = path.getOrDefault("clusterId")
  valid_579465 = validateParameter(valid_579465, JString, required = true,
                                 default = nil)
  if valid_579465 != nil:
    section.add "clusterId", valid_579465
  var valid_579466 = path.getOrDefault("zone")
  valid_579466 = validateParameter(valid_579466, JString, required = true,
                                 default = nil)
  if valid_579466 != nil:
    section.add "zone", valid_579466
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579467 = query.getOrDefault("key")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "key", valid_579467
  var valid_579468 = query.getOrDefault("pp")
  valid_579468 = validateParameter(valid_579468, JBool, required = false,
                                 default = newJBool(true))
  if valid_579468 != nil:
    section.add "pp", valid_579468
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
  var valid_579472 = query.getOrDefault("bearer_token")
  valid_579472 = validateParameter(valid_579472, JString, required = false,
                                 default = nil)
  if valid_579472 != nil:
    section.add "bearer_token", valid_579472
  var valid_579473 = query.getOrDefault("alt")
  valid_579473 = validateParameter(valid_579473, JString, required = false,
                                 default = newJString("json"))
  if valid_579473 != nil:
    section.add "alt", valid_579473
  var valid_579474 = query.getOrDefault("uploadType")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "uploadType", valid_579474
  var valid_579475 = query.getOrDefault("quotaUser")
  valid_579475 = validateParameter(valid_579475, JString, required = false,
                                 default = nil)
  if valid_579475 != nil:
    section.add "quotaUser", valid_579475
  var valid_579476 = query.getOrDefault("callback")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "callback", valid_579476
  var valid_579477 = query.getOrDefault("fields")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "fields", valid_579477
  var valid_579478 = query.getOrDefault("access_token")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "access_token", valid_579478
  var valid_579479 = query.getOrDefault("upload_protocol")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "upload_protocol", valid_579479
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

proc call*(call_579481: Call_ContainerProjectsZonesClustersSetNetworkPolicy_579461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  let valid = call_579481.validator(path, query, header, formData, body)
  let scheme = call_579481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579481.url(scheme.get, call_579481.host, call_579481.base,
                         call_579481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579481, url, valid)

proc call*(call_579482: Call_ContainerProjectsZonesClustersSetNetworkPolicy_579461;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersSetNetworkPolicy
  ## Enables/Disables Network Policy for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579483 = newJObject()
  var query_579484 = newJObject()
  var body_579485 = newJObject()
  add(query_579484, "key", newJString(key))
  add(query_579484, "pp", newJBool(pp))
  add(query_579484, "prettyPrint", newJBool(prettyPrint))
  add(query_579484, "oauth_token", newJString(oauthToken))
  add(path_579483, "projectId", newJString(projectId))
  add(query_579484, "$.xgafv", newJString(Xgafv))
  add(query_579484, "bearer_token", newJString(bearerToken))
  add(query_579484, "alt", newJString(alt))
  add(query_579484, "uploadType", newJString(uploadType))
  add(query_579484, "quotaUser", newJString(quotaUser))
  add(path_579483, "clusterId", newJString(clusterId))
  add(path_579483, "zone", newJString(zone))
  if body != nil:
    body_579485 = body
  add(query_579484, "callback", newJString(callback))
  add(query_579484, "fields", newJString(fields))
  add(query_579484, "access_token", newJString(accessToken))
  add(query_579484, "upload_protocol", newJString(uploadProtocol))
  result = call_579482.call(path_579483, query_579484, nil, nil, body_579485)

var containerProjectsZonesClustersSetNetworkPolicy* = Call_ContainerProjectsZonesClustersSetNetworkPolicy_579461(
    name: "containerProjectsZonesClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setNetworkPolicy",
    validator: validate_ContainerProjectsZonesClustersSetNetworkPolicy_579462,
    base: "/", url: url_ContainerProjectsZonesClustersSetNetworkPolicy_579463,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersStartIpRotation_579486 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesClustersStartIpRotation_579488(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersStartIpRotation_579487(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Start master IP rotation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   clusterId: JString (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579489 = path.getOrDefault("projectId")
  valid_579489 = validateParameter(valid_579489, JString, required = true,
                                 default = nil)
  if valid_579489 != nil:
    section.add "projectId", valid_579489
  var valid_579490 = path.getOrDefault("clusterId")
  valid_579490 = validateParameter(valid_579490, JString, required = true,
                                 default = nil)
  if valid_579490 != nil:
    section.add "clusterId", valid_579490
  var valid_579491 = path.getOrDefault("zone")
  valid_579491 = validateParameter(valid_579491, JString, required = true,
                                 default = nil)
  if valid_579491 != nil:
    section.add "zone", valid_579491
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579492 = query.getOrDefault("key")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "key", valid_579492
  var valid_579493 = query.getOrDefault("pp")
  valid_579493 = validateParameter(valid_579493, JBool, required = false,
                                 default = newJBool(true))
  if valid_579493 != nil:
    section.add "pp", valid_579493
  var valid_579494 = query.getOrDefault("prettyPrint")
  valid_579494 = validateParameter(valid_579494, JBool, required = false,
                                 default = newJBool(true))
  if valid_579494 != nil:
    section.add "prettyPrint", valid_579494
  var valid_579495 = query.getOrDefault("oauth_token")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = nil)
  if valid_579495 != nil:
    section.add "oauth_token", valid_579495
  var valid_579496 = query.getOrDefault("$.xgafv")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = newJString("1"))
  if valid_579496 != nil:
    section.add "$.xgafv", valid_579496
  var valid_579497 = query.getOrDefault("bearer_token")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "bearer_token", valid_579497
  var valid_579498 = query.getOrDefault("alt")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = newJString("json"))
  if valid_579498 != nil:
    section.add "alt", valid_579498
  var valid_579499 = query.getOrDefault("uploadType")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "uploadType", valid_579499
  var valid_579500 = query.getOrDefault("quotaUser")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "quotaUser", valid_579500
  var valid_579501 = query.getOrDefault("callback")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "callback", valid_579501
  var valid_579502 = query.getOrDefault("fields")
  valid_579502 = validateParameter(valid_579502, JString, required = false,
                                 default = nil)
  if valid_579502 != nil:
    section.add "fields", valid_579502
  var valid_579503 = query.getOrDefault("access_token")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = nil)
  if valid_579503 != nil:
    section.add "access_token", valid_579503
  var valid_579504 = query.getOrDefault("upload_protocol")
  valid_579504 = validateParameter(valid_579504, JString, required = false,
                                 default = nil)
  if valid_579504 != nil:
    section.add "upload_protocol", valid_579504
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

proc call*(call_579506: Call_ContainerProjectsZonesClustersStartIpRotation_579486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start master IP rotation.
  ## 
  let valid = call_579506.validator(path, query, header, formData, body)
  let scheme = call_579506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579506.url(scheme.get, call_579506.host, call_579506.base,
                         call_579506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579506, url, valid)

proc call*(call_579507: Call_ContainerProjectsZonesClustersStartIpRotation_579486;
          projectId: string; clusterId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesClustersStartIpRotation
  ## Start master IP rotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string (required)
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579508 = newJObject()
  var query_579509 = newJObject()
  var body_579510 = newJObject()
  add(query_579509, "key", newJString(key))
  add(query_579509, "pp", newJBool(pp))
  add(query_579509, "prettyPrint", newJBool(prettyPrint))
  add(query_579509, "oauth_token", newJString(oauthToken))
  add(path_579508, "projectId", newJString(projectId))
  add(query_579509, "$.xgafv", newJString(Xgafv))
  add(query_579509, "bearer_token", newJString(bearerToken))
  add(query_579509, "alt", newJString(alt))
  add(query_579509, "uploadType", newJString(uploadType))
  add(query_579509, "quotaUser", newJString(quotaUser))
  add(path_579508, "clusterId", newJString(clusterId))
  add(path_579508, "zone", newJString(zone))
  if body != nil:
    body_579510 = body
  add(query_579509, "callback", newJString(callback))
  add(query_579509, "fields", newJString(fields))
  add(query_579509, "access_token", newJString(accessToken))
  add(query_579509, "upload_protocol", newJString(uploadProtocol))
  result = call_579507.call(path_579508, query_579509, nil, nil, body_579510)

var containerProjectsZonesClustersStartIpRotation* = Call_ContainerProjectsZonesClustersStartIpRotation_579486(
    name: "containerProjectsZonesClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:startIpRotation",
    validator: validate_ContainerProjectsZonesClustersStartIpRotation_579487,
    base: "/", url: url_ContainerProjectsZonesClustersStartIpRotation_579488,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsList_579511 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesOperationsList_579513(protocol: Scheme;
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

proc validate_ContainerProjectsZonesOperationsList_579512(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579514 = path.getOrDefault("projectId")
  valid_579514 = validateParameter(valid_579514, JString, required = true,
                                 default = nil)
  if valid_579514 != nil:
    section.add "projectId", valid_579514
  var valid_579515 = path.getOrDefault("zone")
  valid_579515 = validateParameter(valid_579515, JString, required = true,
                                 default = nil)
  if valid_579515 != nil:
    section.add "zone", valid_579515
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579516 = query.getOrDefault("key")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "key", valid_579516
  var valid_579517 = query.getOrDefault("pp")
  valid_579517 = validateParameter(valid_579517, JBool, required = false,
                                 default = newJBool(true))
  if valid_579517 != nil:
    section.add "pp", valid_579517
  var valid_579518 = query.getOrDefault("prettyPrint")
  valid_579518 = validateParameter(valid_579518, JBool, required = false,
                                 default = newJBool(true))
  if valid_579518 != nil:
    section.add "prettyPrint", valid_579518
  var valid_579519 = query.getOrDefault("oauth_token")
  valid_579519 = validateParameter(valid_579519, JString, required = false,
                                 default = nil)
  if valid_579519 != nil:
    section.add "oauth_token", valid_579519
  var valid_579520 = query.getOrDefault("$.xgafv")
  valid_579520 = validateParameter(valid_579520, JString, required = false,
                                 default = newJString("1"))
  if valid_579520 != nil:
    section.add "$.xgafv", valid_579520
  var valid_579521 = query.getOrDefault("bearer_token")
  valid_579521 = validateParameter(valid_579521, JString, required = false,
                                 default = nil)
  if valid_579521 != nil:
    section.add "bearer_token", valid_579521
  var valid_579522 = query.getOrDefault("alt")
  valid_579522 = validateParameter(valid_579522, JString, required = false,
                                 default = newJString("json"))
  if valid_579522 != nil:
    section.add "alt", valid_579522
  var valid_579523 = query.getOrDefault("uploadType")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = nil)
  if valid_579523 != nil:
    section.add "uploadType", valid_579523
  var valid_579524 = query.getOrDefault("parent")
  valid_579524 = validateParameter(valid_579524, JString, required = false,
                                 default = nil)
  if valid_579524 != nil:
    section.add "parent", valid_579524
  var valid_579525 = query.getOrDefault("quotaUser")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "quotaUser", valid_579525
  var valid_579526 = query.getOrDefault("callback")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = nil)
  if valid_579526 != nil:
    section.add "callback", valid_579526
  var valid_579527 = query.getOrDefault("fields")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "fields", valid_579527
  var valid_579528 = query.getOrDefault("access_token")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "access_token", valid_579528
  var valid_579529 = query.getOrDefault("upload_protocol")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "upload_protocol", valid_579529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579530: Call_ContainerProjectsZonesOperationsList_579511;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_579530.validator(path, query, header, formData, body)
  let scheme = call_579530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579530.url(scheme.get, call_579530.host, call_579530.base,
                         call_579530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579530, url, valid)

proc call*(call_579531: Call_ContainerProjectsZonesOperationsList_579511;
          projectId: string; zone: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          bearerToken: string = ""; alt: string = "json"; uploadType: string = "";
          parent: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579532 = newJObject()
  var query_579533 = newJObject()
  add(query_579533, "key", newJString(key))
  add(query_579533, "pp", newJBool(pp))
  add(query_579533, "prettyPrint", newJBool(prettyPrint))
  add(query_579533, "oauth_token", newJString(oauthToken))
  add(path_579532, "projectId", newJString(projectId))
  add(query_579533, "$.xgafv", newJString(Xgafv))
  add(query_579533, "bearer_token", newJString(bearerToken))
  add(query_579533, "alt", newJString(alt))
  add(query_579533, "uploadType", newJString(uploadType))
  add(query_579533, "parent", newJString(parent))
  add(query_579533, "quotaUser", newJString(quotaUser))
  add(path_579532, "zone", newJString(zone))
  add(query_579533, "callback", newJString(callback))
  add(query_579533, "fields", newJString(fields))
  add(query_579533, "access_token", newJString(accessToken))
  add(query_579533, "upload_protocol", newJString(uploadProtocol))
  result = call_579531.call(path_579532, query_579533, nil, nil, nil)

var containerProjectsZonesOperationsList* = Call_ContainerProjectsZonesOperationsList_579511(
    name: "containerProjectsZonesOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/operations",
    validator: validate_ContainerProjectsZonesOperationsList_579512, base: "/",
    url: url_ContainerProjectsZonesOperationsList_579513, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsGet_579534 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesOperationsGet_579536(protocol: Scheme; host: string;
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

proc validate_ContainerProjectsZonesOperationsGet_579535(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   operationId: JString (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579537 = path.getOrDefault("projectId")
  valid_579537 = validateParameter(valid_579537, JString, required = true,
                                 default = nil)
  if valid_579537 != nil:
    section.add "projectId", valid_579537
  var valid_579538 = path.getOrDefault("operationId")
  valid_579538 = validateParameter(valid_579538, JString, required = true,
                                 default = nil)
  if valid_579538 != nil:
    section.add "operationId", valid_579538
  var valid_579539 = path.getOrDefault("zone")
  valid_579539 = validateParameter(valid_579539, JString, required = true,
                                 default = nil)
  if valid_579539 != nil:
    section.add "zone", valid_579539
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project, location, operation id) of the operation to get.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579540 = query.getOrDefault("key")
  valid_579540 = validateParameter(valid_579540, JString, required = false,
                                 default = nil)
  if valid_579540 != nil:
    section.add "key", valid_579540
  var valid_579541 = query.getOrDefault("pp")
  valid_579541 = validateParameter(valid_579541, JBool, required = false,
                                 default = newJBool(true))
  if valid_579541 != nil:
    section.add "pp", valid_579541
  var valid_579542 = query.getOrDefault("prettyPrint")
  valid_579542 = validateParameter(valid_579542, JBool, required = false,
                                 default = newJBool(true))
  if valid_579542 != nil:
    section.add "prettyPrint", valid_579542
  var valid_579543 = query.getOrDefault("oauth_token")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "oauth_token", valid_579543
  var valid_579544 = query.getOrDefault("name")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "name", valid_579544
  var valid_579545 = query.getOrDefault("$.xgafv")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = newJString("1"))
  if valid_579545 != nil:
    section.add "$.xgafv", valid_579545
  var valid_579546 = query.getOrDefault("bearer_token")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "bearer_token", valid_579546
  var valid_579547 = query.getOrDefault("alt")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = newJString("json"))
  if valid_579547 != nil:
    section.add "alt", valid_579547
  var valid_579548 = query.getOrDefault("uploadType")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "uploadType", valid_579548
  var valid_579549 = query.getOrDefault("quotaUser")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "quotaUser", valid_579549
  var valid_579550 = query.getOrDefault("callback")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = nil)
  if valid_579550 != nil:
    section.add "callback", valid_579550
  var valid_579551 = query.getOrDefault("fields")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "fields", valid_579551
  var valid_579552 = query.getOrDefault("access_token")
  valid_579552 = validateParameter(valid_579552, JString, required = false,
                                 default = nil)
  if valid_579552 != nil:
    section.add "access_token", valid_579552
  var valid_579553 = query.getOrDefault("upload_protocol")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = nil)
  if valid_579553 != nil:
    section.add "upload_protocol", valid_579553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579554: Call_ContainerProjectsZonesOperationsGet_579534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified operation.
  ## 
  let valid = call_579554.validator(path, query, header, formData, body)
  let scheme = call_579554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579554.url(scheme.get, call_579554.host, call_579554.base,
                         call_579554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579554, url, valid)

proc call*(call_579555: Call_ContainerProjectsZonesOperationsGet_579534;
          projectId: string; operationId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesOperationsGet
  ## Gets the specified operation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project, location, operation id) of the operation to get.
  ## Specified in the format 'projects/*/locations/*/operations/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   operationId: string (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579556 = newJObject()
  var query_579557 = newJObject()
  add(query_579557, "key", newJString(key))
  add(query_579557, "pp", newJBool(pp))
  add(query_579557, "prettyPrint", newJBool(prettyPrint))
  add(query_579557, "oauth_token", newJString(oauthToken))
  add(query_579557, "name", newJString(name))
  add(path_579556, "projectId", newJString(projectId))
  add(query_579557, "$.xgafv", newJString(Xgafv))
  add(query_579557, "bearer_token", newJString(bearerToken))
  add(path_579556, "operationId", newJString(operationId))
  add(query_579557, "alt", newJString(alt))
  add(query_579557, "uploadType", newJString(uploadType))
  add(query_579557, "quotaUser", newJString(quotaUser))
  add(path_579556, "zone", newJString(zone))
  add(query_579557, "callback", newJString(callback))
  add(query_579557, "fields", newJString(fields))
  add(query_579557, "access_token", newJString(accessToken))
  add(query_579557, "upload_protocol", newJString(uploadProtocol))
  result = call_579555.call(path_579556, query_579557, nil, nil, nil)

var containerProjectsZonesOperationsGet* = Call_ContainerProjectsZonesOperationsGet_579534(
    name: "containerProjectsZonesOperationsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/operations/{operationId}",
    validator: validate_ContainerProjectsZonesOperationsGet_579535, base: "/",
    url: url_ContainerProjectsZonesOperationsGet_579536, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsCancel_579558 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesOperationsCancel_579560(protocol: Scheme;
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

proc validate_ContainerProjectsZonesOperationsCancel_579559(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the specified operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   operationId: JString (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579561 = path.getOrDefault("projectId")
  valid_579561 = validateParameter(valid_579561, JString, required = true,
                                 default = nil)
  if valid_579561 != nil:
    section.add "projectId", valid_579561
  var valid_579562 = path.getOrDefault("operationId")
  valid_579562 = validateParameter(valid_579562, JString, required = true,
                                 default = nil)
  if valid_579562 != nil:
    section.add "operationId", valid_579562
  var valid_579563 = path.getOrDefault("zone")
  valid_579563 = validateParameter(valid_579563, JString, required = true,
                                 default = nil)
  if valid_579563 != nil:
    section.add "zone", valid_579563
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579564 = query.getOrDefault("key")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = nil)
  if valid_579564 != nil:
    section.add "key", valid_579564
  var valid_579565 = query.getOrDefault("pp")
  valid_579565 = validateParameter(valid_579565, JBool, required = false,
                                 default = newJBool(true))
  if valid_579565 != nil:
    section.add "pp", valid_579565
  var valid_579566 = query.getOrDefault("prettyPrint")
  valid_579566 = validateParameter(valid_579566, JBool, required = false,
                                 default = newJBool(true))
  if valid_579566 != nil:
    section.add "prettyPrint", valid_579566
  var valid_579567 = query.getOrDefault("oauth_token")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = nil)
  if valid_579567 != nil:
    section.add "oauth_token", valid_579567
  var valid_579568 = query.getOrDefault("$.xgafv")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = newJString("1"))
  if valid_579568 != nil:
    section.add "$.xgafv", valid_579568
  var valid_579569 = query.getOrDefault("bearer_token")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = nil)
  if valid_579569 != nil:
    section.add "bearer_token", valid_579569
  var valid_579570 = query.getOrDefault("alt")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = newJString("json"))
  if valid_579570 != nil:
    section.add "alt", valid_579570
  var valid_579571 = query.getOrDefault("uploadType")
  valid_579571 = validateParameter(valid_579571, JString, required = false,
                                 default = nil)
  if valid_579571 != nil:
    section.add "uploadType", valid_579571
  var valid_579572 = query.getOrDefault("quotaUser")
  valid_579572 = validateParameter(valid_579572, JString, required = false,
                                 default = nil)
  if valid_579572 != nil:
    section.add "quotaUser", valid_579572
  var valid_579573 = query.getOrDefault("callback")
  valid_579573 = validateParameter(valid_579573, JString, required = false,
                                 default = nil)
  if valid_579573 != nil:
    section.add "callback", valid_579573
  var valid_579574 = query.getOrDefault("fields")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "fields", valid_579574
  var valid_579575 = query.getOrDefault("access_token")
  valid_579575 = validateParameter(valid_579575, JString, required = false,
                                 default = nil)
  if valid_579575 != nil:
    section.add "access_token", valid_579575
  var valid_579576 = query.getOrDefault("upload_protocol")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = nil)
  if valid_579576 != nil:
    section.add "upload_protocol", valid_579576
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

proc call*(call_579578: Call_ContainerProjectsZonesOperationsCancel_579558;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_579578.validator(path, query, header, formData, body)
  let scheme = call_579578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579578.url(scheme.get, call_579578.host, call_579578.base,
                         call_579578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579578, url, valid)

proc call*(call_579579: Call_ContainerProjectsZonesOperationsCancel_579558;
          projectId: string; operationId: string; zone: string; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesOperationsCancel
  ## Cancels the specified operation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   operationId: string (required)
  ##              : The server-assigned `name` of the operation.
  ## This field is deprecated, use name instead.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the operation resides.
  ## This field is deprecated, use name instead.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579580 = newJObject()
  var query_579581 = newJObject()
  var body_579582 = newJObject()
  add(query_579581, "key", newJString(key))
  add(query_579581, "pp", newJBool(pp))
  add(query_579581, "prettyPrint", newJBool(prettyPrint))
  add(query_579581, "oauth_token", newJString(oauthToken))
  add(path_579580, "projectId", newJString(projectId))
  add(query_579581, "$.xgafv", newJString(Xgafv))
  add(query_579581, "bearer_token", newJString(bearerToken))
  add(path_579580, "operationId", newJString(operationId))
  add(query_579581, "alt", newJString(alt))
  add(query_579581, "uploadType", newJString(uploadType))
  add(query_579581, "quotaUser", newJString(quotaUser))
  add(path_579580, "zone", newJString(zone))
  if body != nil:
    body_579582 = body
  add(query_579581, "callback", newJString(callback))
  add(query_579581, "fields", newJString(fields))
  add(query_579581, "access_token", newJString(accessToken))
  add(query_579581, "upload_protocol", newJString(uploadProtocol))
  result = call_579579.call(path_579580, query_579581, nil, nil, body_579582)

var containerProjectsZonesOperationsCancel* = Call_ContainerProjectsZonesOperationsCancel_579558(
    name: "containerProjectsZonesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/projects/{projectId}/zones/{zone}/operations/{operationId}:cancel",
    validator: validate_ContainerProjectsZonesOperationsCancel_579559, base: "/",
    url: url_ContainerProjectsZonesOperationsCancel_579560,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesGetServerconfig_579583 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsZonesGetServerconfig_579585(protocol: Scheme;
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

proc validate_ContainerProjectsZonesGetServerconfig_579584(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns configuration info about the Container Engine service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   zone: JString (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579586 = path.getOrDefault("projectId")
  valid_579586 = validateParameter(valid_579586, JString, required = true,
                                 default = nil)
  if valid_579586 != nil:
    section.add "projectId", valid_579586
  var valid_579587 = path.getOrDefault("zone")
  valid_579587 = validateParameter(valid_579587, JString, required = true,
                                 default = nil)
  if valid_579587 != nil:
    section.add "zone", valid_579587
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579588 = query.getOrDefault("key")
  valid_579588 = validateParameter(valid_579588, JString, required = false,
                                 default = nil)
  if valid_579588 != nil:
    section.add "key", valid_579588
  var valid_579589 = query.getOrDefault("pp")
  valid_579589 = validateParameter(valid_579589, JBool, required = false,
                                 default = newJBool(true))
  if valid_579589 != nil:
    section.add "pp", valid_579589
  var valid_579590 = query.getOrDefault("prettyPrint")
  valid_579590 = validateParameter(valid_579590, JBool, required = false,
                                 default = newJBool(true))
  if valid_579590 != nil:
    section.add "prettyPrint", valid_579590
  var valid_579591 = query.getOrDefault("oauth_token")
  valid_579591 = validateParameter(valid_579591, JString, required = false,
                                 default = nil)
  if valid_579591 != nil:
    section.add "oauth_token", valid_579591
  var valid_579592 = query.getOrDefault("name")
  valid_579592 = validateParameter(valid_579592, JString, required = false,
                                 default = nil)
  if valid_579592 != nil:
    section.add "name", valid_579592
  var valid_579593 = query.getOrDefault("$.xgafv")
  valid_579593 = validateParameter(valid_579593, JString, required = false,
                                 default = newJString("1"))
  if valid_579593 != nil:
    section.add "$.xgafv", valid_579593
  var valid_579594 = query.getOrDefault("bearer_token")
  valid_579594 = validateParameter(valid_579594, JString, required = false,
                                 default = nil)
  if valid_579594 != nil:
    section.add "bearer_token", valid_579594
  var valid_579595 = query.getOrDefault("alt")
  valid_579595 = validateParameter(valid_579595, JString, required = false,
                                 default = newJString("json"))
  if valid_579595 != nil:
    section.add "alt", valid_579595
  var valid_579596 = query.getOrDefault("uploadType")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = nil)
  if valid_579596 != nil:
    section.add "uploadType", valid_579596
  var valid_579597 = query.getOrDefault("quotaUser")
  valid_579597 = validateParameter(valid_579597, JString, required = false,
                                 default = nil)
  if valid_579597 != nil:
    section.add "quotaUser", valid_579597
  var valid_579598 = query.getOrDefault("callback")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = nil)
  if valid_579598 != nil:
    section.add "callback", valid_579598
  var valid_579599 = query.getOrDefault("fields")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = nil)
  if valid_579599 != nil:
    section.add "fields", valid_579599
  var valid_579600 = query.getOrDefault("access_token")
  valid_579600 = validateParameter(valid_579600, JString, required = false,
                                 default = nil)
  if valid_579600 != nil:
    section.add "access_token", valid_579600
  var valid_579601 = query.getOrDefault("upload_protocol")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "upload_protocol", valid_579601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579602: Call_ContainerProjectsZonesGetServerconfig_579583;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Container Engine service.
  ## 
  let valid = call_579602.validator(path, query, header, formData, body)
  let scheme = call_579602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579602.url(scheme.get, call_579602.host, call_579602.base,
                         call_579602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579602, url, valid)

proc call*(call_579603: Call_ContainerProjectsZonesGetServerconfig_579583;
          projectId: string; zone: string; key: string = ""; pp: bool = true;
          prettyPrint: bool = true; oauthToken: string = ""; name: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsZonesGetServerconfig
  ## Returns configuration info about the Container Engine service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  ##   projectId: string (required)
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string (required)
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579604 = newJObject()
  var query_579605 = newJObject()
  add(query_579605, "key", newJString(key))
  add(query_579605, "pp", newJBool(pp))
  add(query_579605, "prettyPrint", newJBool(prettyPrint))
  add(query_579605, "oauth_token", newJString(oauthToken))
  add(query_579605, "name", newJString(name))
  add(path_579604, "projectId", newJString(projectId))
  add(query_579605, "$.xgafv", newJString(Xgafv))
  add(query_579605, "bearer_token", newJString(bearerToken))
  add(query_579605, "alt", newJString(alt))
  add(query_579605, "uploadType", newJString(uploadType))
  add(query_579605, "quotaUser", newJString(quotaUser))
  add(path_579604, "zone", newJString(zone))
  add(query_579605, "callback", newJString(callback))
  add(query_579605, "fields", newJString(fields))
  add(query_579605, "access_token", newJString(accessToken))
  add(query_579605, "upload_protocol", newJString(uploadProtocol))
  result = call_579603.call(path_579604, query_579605, nil, nil, nil)

var containerProjectsZonesGetServerconfig* = Call_ContainerProjectsZonesGetServerconfig_579583(
    name: "containerProjectsZonesGetServerconfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1beta1/projects/{projectId}/zones/{zone}/serverconfig",
    validator: validate_ContainerProjectsZonesGetServerconfig_579584, base: "/",
    url: url_ContainerProjectsZonesGetServerconfig_579585, schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsUpdate_579631 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsUpdate_579633(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsUpdate_579632(
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
  var valid_579634 = path.getOrDefault("name")
  valid_579634 = validateParameter(valid_579634, JString, required = true,
                                 default = nil)
  if valid_579634 != nil:
    section.add "name", valid_579634
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579635 = query.getOrDefault("key")
  valid_579635 = validateParameter(valid_579635, JString, required = false,
                                 default = nil)
  if valid_579635 != nil:
    section.add "key", valid_579635
  var valid_579636 = query.getOrDefault("pp")
  valid_579636 = validateParameter(valid_579636, JBool, required = false,
                                 default = newJBool(true))
  if valid_579636 != nil:
    section.add "pp", valid_579636
  var valid_579637 = query.getOrDefault("prettyPrint")
  valid_579637 = validateParameter(valid_579637, JBool, required = false,
                                 default = newJBool(true))
  if valid_579637 != nil:
    section.add "prettyPrint", valid_579637
  var valid_579638 = query.getOrDefault("oauth_token")
  valid_579638 = validateParameter(valid_579638, JString, required = false,
                                 default = nil)
  if valid_579638 != nil:
    section.add "oauth_token", valid_579638
  var valid_579639 = query.getOrDefault("$.xgafv")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = newJString("1"))
  if valid_579639 != nil:
    section.add "$.xgafv", valid_579639
  var valid_579640 = query.getOrDefault("bearer_token")
  valid_579640 = validateParameter(valid_579640, JString, required = false,
                                 default = nil)
  if valid_579640 != nil:
    section.add "bearer_token", valid_579640
  var valid_579641 = query.getOrDefault("alt")
  valid_579641 = validateParameter(valid_579641, JString, required = false,
                                 default = newJString("json"))
  if valid_579641 != nil:
    section.add "alt", valid_579641
  var valid_579642 = query.getOrDefault("uploadType")
  valid_579642 = validateParameter(valid_579642, JString, required = false,
                                 default = nil)
  if valid_579642 != nil:
    section.add "uploadType", valid_579642
  var valid_579643 = query.getOrDefault("quotaUser")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "quotaUser", valid_579643
  var valid_579644 = query.getOrDefault("callback")
  valid_579644 = validateParameter(valid_579644, JString, required = false,
                                 default = nil)
  if valid_579644 != nil:
    section.add "callback", valid_579644
  var valid_579645 = query.getOrDefault("fields")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "fields", valid_579645
  var valid_579646 = query.getOrDefault("access_token")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = nil)
  if valid_579646 != nil:
    section.add "access_token", valid_579646
  var valid_579647 = query.getOrDefault("upload_protocol")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = nil)
  if valid_579647 != nil:
    section.add "upload_protocol", valid_579647
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

proc call*(call_579649: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_579631;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or iamge type of a specific node pool.
  ## 
  let valid = call_579649.validator(path, query, header, formData, body)
  let scheme = call_579649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579649.url(scheme.get, call_579649.host, call_579649.base,
                         call_579649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579649, url, valid)

proc call*(call_579650: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_579631;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsUpdate
  ## Updates the version and/or iamge type of a specific node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool) of the node pool to update.
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
  var path_579651 = newJObject()
  var query_579652 = newJObject()
  var body_579653 = newJObject()
  add(query_579652, "key", newJString(key))
  add(query_579652, "pp", newJBool(pp))
  add(query_579652, "prettyPrint", newJBool(prettyPrint))
  add(query_579652, "oauth_token", newJString(oauthToken))
  add(query_579652, "$.xgafv", newJString(Xgafv))
  add(query_579652, "bearer_token", newJString(bearerToken))
  add(query_579652, "alt", newJString(alt))
  add(query_579652, "uploadType", newJString(uploadType))
  add(query_579652, "quotaUser", newJString(quotaUser))
  add(path_579651, "name", newJString(name))
  if body != nil:
    body_579653 = body
  add(query_579652, "callback", newJString(callback))
  add(query_579652, "fields", newJString(fields))
  add(query_579652, "access_token", newJString(accessToken))
  add(query_579652, "upload_protocol", newJString(uploadProtocol))
  result = call_579650.call(path_579651, query_579652, nil, nil, body_579653)

var containerProjectsLocationsClustersNodePoolsUpdate* = Call_ContainerProjectsLocationsClustersNodePoolsUpdate_579631(
    name: "containerProjectsLocationsClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPut, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsUpdate_579632,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsUpdate_579633,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsGet_579606 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsGet_579608(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersNodePoolsGet_579607(
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
  var valid_579609 = path.getOrDefault("name")
  valid_579609 = validateParameter(valid_579609, JString, required = true,
                                 default = nil)
  if valid_579609 != nil:
    section.add "name", valid_579609
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   nodePoolId: JString
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   clusterId: JString
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  section = newJObject()
  var valid_579610 = query.getOrDefault("key")
  valid_579610 = validateParameter(valid_579610, JString, required = false,
                                 default = nil)
  if valid_579610 != nil:
    section.add "key", valid_579610
  var valid_579611 = query.getOrDefault("pp")
  valid_579611 = validateParameter(valid_579611, JBool, required = false,
                                 default = newJBool(true))
  if valid_579611 != nil:
    section.add "pp", valid_579611
  var valid_579612 = query.getOrDefault("prettyPrint")
  valid_579612 = validateParameter(valid_579612, JBool, required = false,
                                 default = newJBool(true))
  if valid_579612 != nil:
    section.add "prettyPrint", valid_579612
  var valid_579613 = query.getOrDefault("oauth_token")
  valid_579613 = validateParameter(valid_579613, JString, required = false,
                                 default = nil)
  if valid_579613 != nil:
    section.add "oauth_token", valid_579613
  var valid_579614 = query.getOrDefault("$.xgafv")
  valid_579614 = validateParameter(valid_579614, JString, required = false,
                                 default = newJString("1"))
  if valid_579614 != nil:
    section.add "$.xgafv", valid_579614
  var valid_579615 = query.getOrDefault("bearer_token")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = nil)
  if valid_579615 != nil:
    section.add "bearer_token", valid_579615
  var valid_579616 = query.getOrDefault("alt")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = newJString("json"))
  if valid_579616 != nil:
    section.add "alt", valid_579616
  var valid_579617 = query.getOrDefault("uploadType")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "uploadType", valid_579617
  var valid_579618 = query.getOrDefault("quotaUser")
  valid_579618 = validateParameter(valid_579618, JString, required = false,
                                 default = nil)
  if valid_579618 != nil:
    section.add "quotaUser", valid_579618
  var valid_579619 = query.getOrDefault("nodePoolId")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "nodePoolId", valid_579619
  var valid_579620 = query.getOrDefault("clusterId")
  valid_579620 = validateParameter(valid_579620, JString, required = false,
                                 default = nil)
  if valid_579620 != nil:
    section.add "clusterId", valid_579620
  var valid_579621 = query.getOrDefault("zone")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "zone", valid_579621
  var valid_579622 = query.getOrDefault("callback")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "callback", valid_579622
  var valid_579623 = query.getOrDefault("fields")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = nil)
  if valid_579623 != nil:
    section.add "fields", valid_579623
  var valid_579624 = query.getOrDefault("access_token")
  valid_579624 = validateParameter(valid_579624, JString, required = false,
                                 default = nil)
  if valid_579624 != nil:
    section.add "access_token", valid_579624
  var valid_579625 = query.getOrDefault("upload_protocol")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = nil)
  if valid_579625 != nil:
    section.add "upload_protocol", valid_579625
  var valid_579626 = query.getOrDefault("projectId")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "projectId", valid_579626
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579627: Call_ContainerProjectsLocationsClustersNodePoolsGet_579606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the node pool requested.
  ## 
  let valid = call_579627.validator(path, query, header, formData, body)
  let scheme = call_579627.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579627.url(scheme.get, call_579627.host, call_579627.base,
                         call_579627.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579627, url, valid)

proc call*(call_579628: Call_ContainerProjectsLocationsClustersNodePoolsGet_579606;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          nodePoolId: string = ""; clusterId: string = ""; zone: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsGet
  ## Retrieves the node pool requested.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to get.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   nodePoolId: string
  ##             : The name of the node pool.
  ## This field is deprecated, use name instead.
  ##   clusterId: string
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  var path_579629 = newJObject()
  var query_579630 = newJObject()
  add(query_579630, "key", newJString(key))
  add(query_579630, "pp", newJBool(pp))
  add(query_579630, "prettyPrint", newJBool(prettyPrint))
  add(query_579630, "oauth_token", newJString(oauthToken))
  add(query_579630, "$.xgafv", newJString(Xgafv))
  add(query_579630, "bearer_token", newJString(bearerToken))
  add(query_579630, "alt", newJString(alt))
  add(query_579630, "uploadType", newJString(uploadType))
  add(query_579630, "quotaUser", newJString(quotaUser))
  add(path_579629, "name", newJString(name))
  add(query_579630, "nodePoolId", newJString(nodePoolId))
  add(query_579630, "clusterId", newJString(clusterId))
  add(query_579630, "zone", newJString(zone))
  add(query_579630, "callback", newJString(callback))
  add(query_579630, "fields", newJString(fields))
  add(query_579630, "access_token", newJString(accessToken))
  add(query_579630, "upload_protocol", newJString(uploadProtocol))
  add(query_579630, "projectId", newJString(projectId))
  result = call_579628.call(path_579629, query_579630, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsGet* = Call_ContainerProjectsLocationsClustersNodePoolsGet_579606(
    name: "containerProjectsLocationsClustersNodePoolsGet",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsGet_579607,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsGet_579608,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsDelete_579654 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsDelete_579656(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsDelete_579655(
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
  var valid_579657 = path.getOrDefault("name")
  valid_579657 = validateParameter(valid_579657, JString, required = true,
                                 default = nil)
  if valid_579657 != nil:
    section.add "name", valid_579657
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   nodePoolId: JString
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   clusterId: JString
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  section = newJObject()
  var valid_579658 = query.getOrDefault("key")
  valid_579658 = validateParameter(valid_579658, JString, required = false,
                                 default = nil)
  if valid_579658 != nil:
    section.add "key", valid_579658
  var valid_579659 = query.getOrDefault("pp")
  valid_579659 = validateParameter(valid_579659, JBool, required = false,
                                 default = newJBool(true))
  if valid_579659 != nil:
    section.add "pp", valid_579659
  var valid_579660 = query.getOrDefault("prettyPrint")
  valid_579660 = validateParameter(valid_579660, JBool, required = false,
                                 default = newJBool(true))
  if valid_579660 != nil:
    section.add "prettyPrint", valid_579660
  var valid_579661 = query.getOrDefault("oauth_token")
  valid_579661 = validateParameter(valid_579661, JString, required = false,
                                 default = nil)
  if valid_579661 != nil:
    section.add "oauth_token", valid_579661
  var valid_579662 = query.getOrDefault("$.xgafv")
  valid_579662 = validateParameter(valid_579662, JString, required = false,
                                 default = newJString("1"))
  if valid_579662 != nil:
    section.add "$.xgafv", valid_579662
  var valid_579663 = query.getOrDefault("bearer_token")
  valid_579663 = validateParameter(valid_579663, JString, required = false,
                                 default = nil)
  if valid_579663 != nil:
    section.add "bearer_token", valid_579663
  var valid_579664 = query.getOrDefault("alt")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = newJString("json"))
  if valid_579664 != nil:
    section.add "alt", valid_579664
  var valid_579665 = query.getOrDefault("uploadType")
  valid_579665 = validateParameter(valid_579665, JString, required = false,
                                 default = nil)
  if valid_579665 != nil:
    section.add "uploadType", valid_579665
  var valid_579666 = query.getOrDefault("quotaUser")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = nil)
  if valid_579666 != nil:
    section.add "quotaUser", valid_579666
  var valid_579667 = query.getOrDefault("nodePoolId")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = nil)
  if valid_579667 != nil:
    section.add "nodePoolId", valid_579667
  var valid_579668 = query.getOrDefault("clusterId")
  valid_579668 = validateParameter(valid_579668, JString, required = false,
                                 default = nil)
  if valid_579668 != nil:
    section.add "clusterId", valid_579668
  var valid_579669 = query.getOrDefault("zone")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = nil)
  if valid_579669 != nil:
    section.add "zone", valid_579669
  var valid_579670 = query.getOrDefault("callback")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "callback", valid_579670
  var valid_579671 = query.getOrDefault("fields")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "fields", valid_579671
  var valid_579672 = query.getOrDefault("access_token")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "access_token", valid_579672
  var valid_579673 = query.getOrDefault("upload_protocol")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "upload_protocol", valid_579673
  var valid_579674 = query.getOrDefault("projectId")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "projectId", valid_579674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579675: Call_ContainerProjectsLocationsClustersNodePoolsDelete_579654;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_579675.validator(path, query, header, formData, body)
  let scheme = call_579675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579675.url(scheme.get, call_579675.host, call_579675.base,
                         call_579675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579675, url, valid)

proc call*(call_579676: Call_ContainerProjectsLocationsClustersNodePoolsDelete_579654;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          nodePoolId: string = ""; clusterId: string = ""; zone: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsDelete
  ## Deletes a node pool from a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster, node pool id) of the node pool to delete.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   nodePoolId: string
  ##             : The name of the node pool to delete.
  ## This field is deprecated, use name instead.
  ##   clusterId: string
  ##            : The name of the cluster.
  ## This field is deprecated, use name instead.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use name instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use name instead.
  var path_579677 = newJObject()
  var query_579678 = newJObject()
  add(query_579678, "key", newJString(key))
  add(query_579678, "pp", newJBool(pp))
  add(query_579678, "prettyPrint", newJBool(prettyPrint))
  add(query_579678, "oauth_token", newJString(oauthToken))
  add(query_579678, "$.xgafv", newJString(Xgafv))
  add(query_579678, "bearer_token", newJString(bearerToken))
  add(query_579678, "alt", newJString(alt))
  add(query_579678, "uploadType", newJString(uploadType))
  add(query_579678, "quotaUser", newJString(quotaUser))
  add(path_579677, "name", newJString(name))
  add(query_579678, "nodePoolId", newJString(nodePoolId))
  add(query_579678, "clusterId", newJString(clusterId))
  add(query_579678, "zone", newJString(zone))
  add(query_579678, "callback", newJString(callback))
  add(query_579678, "fields", newJString(fields))
  add(query_579678, "access_token", newJString(accessToken))
  add(query_579678, "upload_protocol", newJString(uploadProtocol))
  add(query_579678, "projectId", newJString(projectId))
  result = call_579676.call(path_579677, query_579678, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsDelete* = Call_ContainerProjectsLocationsClustersNodePoolsDelete_579654(
    name: "containerProjectsLocationsClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsDelete_579655,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsDelete_579656,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsGetServerConfig_579679 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsGetServerConfig_579681(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsGetServerConfig_579680(path: JsonNode;
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
  var valid_579682 = path.getOrDefault("name")
  valid_579682 = validateParameter(valid_579682, JString, required = true,
                                 default = nil)
  if valid_579682 != nil:
    section.add "name", valid_579682
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: JString
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  section = newJObject()
  var valid_579683 = query.getOrDefault("key")
  valid_579683 = validateParameter(valid_579683, JString, required = false,
                                 default = nil)
  if valid_579683 != nil:
    section.add "key", valid_579683
  var valid_579684 = query.getOrDefault("pp")
  valid_579684 = validateParameter(valid_579684, JBool, required = false,
                                 default = newJBool(true))
  if valid_579684 != nil:
    section.add "pp", valid_579684
  var valid_579685 = query.getOrDefault("prettyPrint")
  valid_579685 = validateParameter(valid_579685, JBool, required = false,
                                 default = newJBool(true))
  if valid_579685 != nil:
    section.add "prettyPrint", valid_579685
  var valid_579686 = query.getOrDefault("oauth_token")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = nil)
  if valid_579686 != nil:
    section.add "oauth_token", valid_579686
  var valid_579687 = query.getOrDefault("$.xgafv")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = newJString("1"))
  if valid_579687 != nil:
    section.add "$.xgafv", valid_579687
  var valid_579688 = query.getOrDefault("bearer_token")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "bearer_token", valid_579688
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
  var valid_579692 = query.getOrDefault("zone")
  valid_579692 = validateParameter(valid_579692, JString, required = false,
                                 default = nil)
  if valid_579692 != nil:
    section.add "zone", valid_579692
  var valid_579693 = query.getOrDefault("callback")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = nil)
  if valid_579693 != nil:
    section.add "callback", valid_579693
  var valid_579694 = query.getOrDefault("fields")
  valid_579694 = validateParameter(valid_579694, JString, required = false,
                                 default = nil)
  if valid_579694 != nil:
    section.add "fields", valid_579694
  var valid_579695 = query.getOrDefault("access_token")
  valid_579695 = validateParameter(valid_579695, JString, required = false,
                                 default = nil)
  if valid_579695 != nil:
    section.add "access_token", valid_579695
  var valid_579696 = query.getOrDefault("upload_protocol")
  valid_579696 = validateParameter(valid_579696, JString, required = false,
                                 default = nil)
  if valid_579696 != nil:
    section.add "upload_protocol", valid_579696
  var valid_579697 = query.getOrDefault("projectId")
  valid_579697 = validateParameter(valid_579697, JString, required = false,
                                 default = nil)
  if valid_579697 != nil:
    section.add "projectId", valid_579697
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579698: Call_ContainerProjectsLocationsGetServerConfig_579679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Container Engine service.
  ## 
  let valid = call_579698.validator(path, query, header, formData, body)
  let scheme = call_579698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579698.url(scheme.get, call_579698.host, call_579698.base,
                         call_579698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579698, url, valid)

proc call*(call_579699: Call_ContainerProjectsLocationsGetServerConfig_579679;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          zone: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## containerProjectsLocationsGetServerConfig
  ## Returns configuration info about the Container Engine service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project and location) of the server config to get
  ## Specified in the format 'projects/*/locations/*'.
  ##   zone: string
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for.
  ## This field is deprecated, use name instead.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use name instead.
  var path_579700 = newJObject()
  var query_579701 = newJObject()
  add(query_579701, "key", newJString(key))
  add(query_579701, "pp", newJBool(pp))
  add(query_579701, "prettyPrint", newJBool(prettyPrint))
  add(query_579701, "oauth_token", newJString(oauthToken))
  add(query_579701, "$.xgafv", newJString(Xgafv))
  add(query_579701, "bearer_token", newJString(bearerToken))
  add(query_579701, "alt", newJString(alt))
  add(query_579701, "uploadType", newJString(uploadType))
  add(query_579701, "quotaUser", newJString(quotaUser))
  add(path_579700, "name", newJString(name))
  add(query_579701, "zone", newJString(zone))
  add(query_579701, "callback", newJString(callback))
  add(query_579701, "fields", newJString(fields))
  add(query_579701, "access_token", newJString(accessToken))
  add(query_579701, "upload_protocol", newJString(uploadProtocol))
  add(query_579701, "projectId", newJString(projectId))
  result = call_579699.call(path_579700, query_579701, nil, nil, nil)

var containerProjectsLocationsGetServerConfig* = Call_ContainerProjectsLocationsGetServerConfig_579679(
    name: "containerProjectsLocationsGetServerConfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{name}/serverConfig",
    validator: validate_ContainerProjectsLocationsGetServerConfig_579680,
    base: "/", url: url_ContainerProjectsLocationsGetServerConfig_579681,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsCancel_579702 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsOperationsCancel_579704(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsOperationsCancel_579703(path: JsonNode;
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
  var valid_579705 = path.getOrDefault("name")
  valid_579705 = validateParameter(valid_579705, JString, required = true,
                                 default = nil)
  if valid_579705 != nil:
    section.add "name", valid_579705
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579707 = query.getOrDefault("pp")
  valid_579707 = validateParameter(valid_579707, JBool, required = false,
                                 default = newJBool(true))
  if valid_579707 != nil:
    section.add "pp", valid_579707
  var valid_579708 = query.getOrDefault("prettyPrint")
  valid_579708 = validateParameter(valid_579708, JBool, required = false,
                                 default = newJBool(true))
  if valid_579708 != nil:
    section.add "prettyPrint", valid_579708
  var valid_579709 = query.getOrDefault("oauth_token")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = nil)
  if valid_579709 != nil:
    section.add "oauth_token", valid_579709
  var valid_579710 = query.getOrDefault("$.xgafv")
  valid_579710 = validateParameter(valid_579710, JString, required = false,
                                 default = newJString("1"))
  if valid_579710 != nil:
    section.add "$.xgafv", valid_579710
  var valid_579711 = query.getOrDefault("bearer_token")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "bearer_token", valid_579711
  var valid_579712 = query.getOrDefault("alt")
  valid_579712 = validateParameter(valid_579712, JString, required = false,
                                 default = newJString("json"))
  if valid_579712 != nil:
    section.add "alt", valid_579712
  var valid_579713 = query.getOrDefault("uploadType")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "uploadType", valid_579713
  var valid_579714 = query.getOrDefault("quotaUser")
  valid_579714 = validateParameter(valid_579714, JString, required = false,
                                 default = nil)
  if valid_579714 != nil:
    section.add "quotaUser", valid_579714
  var valid_579715 = query.getOrDefault("callback")
  valid_579715 = validateParameter(valid_579715, JString, required = false,
                                 default = nil)
  if valid_579715 != nil:
    section.add "callback", valid_579715
  var valid_579716 = query.getOrDefault("fields")
  valid_579716 = validateParameter(valid_579716, JString, required = false,
                                 default = nil)
  if valid_579716 != nil:
    section.add "fields", valid_579716
  var valid_579717 = query.getOrDefault("access_token")
  valid_579717 = validateParameter(valid_579717, JString, required = false,
                                 default = nil)
  if valid_579717 != nil:
    section.add "access_token", valid_579717
  var valid_579718 = query.getOrDefault("upload_protocol")
  valid_579718 = validateParameter(valid_579718, JString, required = false,
                                 default = nil)
  if valid_579718 != nil:
    section.add "upload_protocol", valid_579718
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

proc call*(call_579720: Call_ContainerProjectsLocationsOperationsCancel_579702;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_579720.validator(path, query, header, formData, body)
  let scheme = call_579720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579720.url(scheme.get, call_579720.host, call_579720.base,
                         call_579720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579720, url, valid)

proc call*(call_579721: Call_ContainerProjectsLocationsOperationsCancel_579702;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsOperationsCancel
  ## Cancels the specified operation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579722 = newJObject()
  var query_579723 = newJObject()
  var body_579724 = newJObject()
  add(query_579723, "key", newJString(key))
  add(query_579723, "pp", newJBool(pp))
  add(query_579723, "prettyPrint", newJBool(prettyPrint))
  add(query_579723, "oauth_token", newJString(oauthToken))
  add(query_579723, "$.xgafv", newJString(Xgafv))
  add(query_579723, "bearer_token", newJString(bearerToken))
  add(query_579723, "alt", newJString(alt))
  add(query_579723, "uploadType", newJString(uploadType))
  add(query_579723, "quotaUser", newJString(quotaUser))
  add(path_579722, "name", newJString(name))
  if body != nil:
    body_579724 = body
  add(query_579723, "callback", newJString(callback))
  add(query_579723, "fields", newJString(fields))
  add(query_579723, "access_token", newJString(accessToken))
  add(query_579723, "upload_protocol", newJString(uploadProtocol))
  result = call_579721.call(path_579722, query_579723, nil, nil, body_579724)

var containerProjectsLocationsOperationsCancel* = Call_ContainerProjectsLocationsOperationsCancel_579702(
    name: "containerProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_ContainerProjectsLocationsOperationsCancel_579703,
    base: "/", url: url_ContainerProjectsLocationsOperationsCancel_579704,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCompleteIpRotation_579725 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersCompleteIpRotation_579727(
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

proc validate_ContainerProjectsLocationsClustersCompleteIpRotation_579726(
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
  var valid_579728 = path.getOrDefault("name")
  valid_579728 = validateParameter(valid_579728, JString, required = true,
                                 default = nil)
  if valid_579728 != nil:
    section.add "name", valid_579728
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579729 = query.getOrDefault("key")
  valid_579729 = validateParameter(valid_579729, JString, required = false,
                                 default = nil)
  if valid_579729 != nil:
    section.add "key", valid_579729
  var valid_579730 = query.getOrDefault("pp")
  valid_579730 = validateParameter(valid_579730, JBool, required = false,
                                 default = newJBool(true))
  if valid_579730 != nil:
    section.add "pp", valid_579730
  var valid_579731 = query.getOrDefault("prettyPrint")
  valid_579731 = validateParameter(valid_579731, JBool, required = false,
                                 default = newJBool(true))
  if valid_579731 != nil:
    section.add "prettyPrint", valid_579731
  var valid_579732 = query.getOrDefault("oauth_token")
  valid_579732 = validateParameter(valid_579732, JString, required = false,
                                 default = nil)
  if valid_579732 != nil:
    section.add "oauth_token", valid_579732
  var valid_579733 = query.getOrDefault("$.xgafv")
  valid_579733 = validateParameter(valid_579733, JString, required = false,
                                 default = newJString("1"))
  if valid_579733 != nil:
    section.add "$.xgafv", valid_579733
  var valid_579734 = query.getOrDefault("bearer_token")
  valid_579734 = validateParameter(valid_579734, JString, required = false,
                                 default = nil)
  if valid_579734 != nil:
    section.add "bearer_token", valid_579734
  var valid_579735 = query.getOrDefault("alt")
  valid_579735 = validateParameter(valid_579735, JString, required = false,
                                 default = newJString("json"))
  if valid_579735 != nil:
    section.add "alt", valid_579735
  var valid_579736 = query.getOrDefault("uploadType")
  valid_579736 = validateParameter(valid_579736, JString, required = false,
                                 default = nil)
  if valid_579736 != nil:
    section.add "uploadType", valid_579736
  var valid_579737 = query.getOrDefault("quotaUser")
  valid_579737 = validateParameter(valid_579737, JString, required = false,
                                 default = nil)
  if valid_579737 != nil:
    section.add "quotaUser", valid_579737
  var valid_579738 = query.getOrDefault("callback")
  valid_579738 = validateParameter(valid_579738, JString, required = false,
                                 default = nil)
  if valid_579738 != nil:
    section.add "callback", valid_579738
  var valid_579739 = query.getOrDefault("fields")
  valid_579739 = validateParameter(valid_579739, JString, required = false,
                                 default = nil)
  if valid_579739 != nil:
    section.add "fields", valid_579739
  var valid_579740 = query.getOrDefault("access_token")
  valid_579740 = validateParameter(valid_579740, JString, required = false,
                                 default = nil)
  if valid_579740 != nil:
    section.add "access_token", valid_579740
  var valid_579741 = query.getOrDefault("upload_protocol")
  valid_579741 = validateParameter(valid_579741, JString, required = false,
                                 default = nil)
  if valid_579741 != nil:
    section.add "upload_protocol", valid_579741
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

proc call*(call_579743: Call_ContainerProjectsLocationsClustersCompleteIpRotation_579725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_579743.validator(path, query, header, formData, body)
  let scheme = call_579743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579743.url(scheme.get, call_579743.host, call_579743.base,
                         call_579743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579743, url, valid)

proc call*(call_579744: Call_ContainerProjectsLocationsClustersCompleteIpRotation_579725;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersCompleteIpRotation
  ## Completes master IP rotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to complete IP rotation.
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
  var path_579745 = newJObject()
  var query_579746 = newJObject()
  var body_579747 = newJObject()
  add(query_579746, "key", newJString(key))
  add(query_579746, "pp", newJBool(pp))
  add(query_579746, "prettyPrint", newJBool(prettyPrint))
  add(query_579746, "oauth_token", newJString(oauthToken))
  add(query_579746, "$.xgafv", newJString(Xgafv))
  add(query_579746, "bearer_token", newJString(bearerToken))
  add(query_579746, "alt", newJString(alt))
  add(query_579746, "uploadType", newJString(uploadType))
  add(query_579746, "quotaUser", newJString(quotaUser))
  add(path_579745, "name", newJString(name))
  if body != nil:
    body_579747 = body
  add(query_579746, "callback", newJString(callback))
  add(query_579746, "fields", newJString(fields))
  add(query_579746, "access_token", newJString(accessToken))
  add(query_579746, "upload_protocol", newJString(uploadProtocol))
  result = call_579744.call(path_579745, query_579746, nil, nil, body_579747)

var containerProjectsLocationsClustersCompleteIpRotation* = Call_ContainerProjectsLocationsClustersCompleteIpRotation_579725(
    name: "containerProjectsLocationsClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:completeIpRotation",
    validator: validate_ContainerProjectsLocationsClustersCompleteIpRotation_579726,
    base: "/", url: url_ContainerProjectsLocationsClustersCompleteIpRotation_579727,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsRollback_579748 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsRollback_579750(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsRollback_579749(
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
  var valid_579751 = path.getOrDefault("name")
  valid_579751 = validateParameter(valid_579751, JString, required = true,
                                 default = nil)
  if valid_579751 != nil:
    section.add "name", valid_579751
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579752 = query.getOrDefault("key")
  valid_579752 = validateParameter(valid_579752, JString, required = false,
                                 default = nil)
  if valid_579752 != nil:
    section.add "key", valid_579752
  var valid_579753 = query.getOrDefault("pp")
  valid_579753 = validateParameter(valid_579753, JBool, required = false,
                                 default = newJBool(true))
  if valid_579753 != nil:
    section.add "pp", valid_579753
  var valid_579754 = query.getOrDefault("prettyPrint")
  valid_579754 = validateParameter(valid_579754, JBool, required = false,
                                 default = newJBool(true))
  if valid_579754 != nil:
    section.add "prettyPrint", valid_579754
  var valid_579755 = query.getOrDefault("oauth_token")
  valid_579755 = validateParameter(valid_579755, JString, required = false,
                                 default = nil)
  if valid_579755 != nil:
    section.add "oauth_token", valid_579755
  var valid_579756 = query.getOrDefault("$.xgafv")
  valid_579756 = validateParameter(valid_579756, JString, required = false,
                                 default = newJString("1"))
  if valid_579756 != nil:
    section.add "$.xgafv", valid_579756
  var valid_579757 = query.getOrDefault("bearer_token")
  valid_579757 = validateParameter(valid_579757, JString, required = false,
                                 default = nil)
  if valid_579757 != nil:
    section.add "bearer_token", valid_579757
  var valid_579758 = query.getOrDefault("alt")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = newJString("json"))
  if valid_579758 != nil:
    section.add "alt", valid_579758
  var valid_579759 = query.getOrDefault("uploadType")
  valid_579759 = validateParameter(valid_579759, JString, required = false,
                                 default = nil)
  if valid_579759 != nil:
    section.add "uploadType", valid_579759
  var valid_579760 = query.getOrDefault("quotaUser")
  valid_579760 = validateParameter(valid_579760, JString, required = false,
                                 default = nil)
  if valid_579760 != nil:
    section.add "quotaUser", valid_579760
  var valid_579761 = query.getOrDefault("callback")
  valid_579761 = validateParameter(valid_579761, JString, required = false,
                                 default = nil)
  if valid_579761 != nil:
    section.add "callback", valid_579761
  var valid_579762 = query.getOrDefault("fields")
  valid_579762 = validateParameter(valid_579762, JString, required = false,
                                 default = nil)
  if valid_579762 != nil:
    section.add "fields", valid_579762
  var valid_579763 = query.getOrDefault("access_token")
  valid_579763 = validateParameter(valid_579763, JString, required = false,
                                 default = nil)
  if valid_579763 != nil:
    section.add "access_token", valid_579763
  var valid_579764 = query.getOrDefault("upload_protocol")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "upload_protocol", valid_579764
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

proc call*(call_579766: Call_ContainerProjectsLocationsClustersNodePoolsRollback_579748;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ## 
  let valid = call_579766.validator(path, query, header, formData, body)
  let scheme = call_579766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579766.url(scheme.get, call_579766.host, call_579766.base,
                         call_579766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579766, url, valid)

proc call*(call_579767: Call_ContainerProjectsLocationsClustersNodePoolsRollback_579748;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsRollback
  ## Roll back the previously Aborted or Failed NodePool upgrade.
  ## This will be an no-op if the last upgrade successfully completed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579768 = newJObject()
  var query_579769 = newJObject()
  var body_579770 = newJObject()
  add(query_579769, "key", newJString(key))
  add(query_579769, "pp", newJBool(pp))
  add(query_579769, "prettyPrint", newJBool(prettyPrint))
  add(query_579769, "oauth_token", newJString(oauthToken))
  add(query_579769, "$.xgafv", newJString(Xgafv))
  add(query_579769, "bearer_token", newJString(bearerToken))
  add(query_579769, "alt", newJString(alt))
  add(query_579769, "uploadType", newJString(uploadType))
  add(query_579769, "quotaUser", newJString(quotaUser))
  add(path_579768, "name", newJString(name))
  if body != nil:
    body_579770 = body
  add(query_579769, "callback", newJString(callback))
  add(query_579769, "fields", newJString(fields))
  add(query_579769, "access_token", newJString(accessToken))
  add(query_579769, "upload_protocol", newJString(uploadProtocol))
  result = call_579767.call(path_579768, query_579769, nil, nil, body_579770)

var containerProjectsLocationsClustersNodePoolsRollback* = Call_ContainerProjectsLocationsClustersNodePoolsRollback_579748(
    name: "containerProjectsLocationsClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:rollback",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsRollback_579749,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsRollback_579750,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetAddons_579771 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetAddons_579773(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetAddons_579772(path: JsonNode;
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
  var valid_579774 = path.getOrDefault("name")
  valid_579774 = validateParameter(valid_579774, JString, required = true,
                                 default = nil)
  if valid_579774 != nil:
    section.add "name", valid_579774
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579775 = query.getOrDefault("key")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "key", valid_579775
  var valid_579776 = query.getOrDefault("pp")
  valid_579776 = validateParameter(valid_579776, JBool, required = false,
                                 default = newJBool(true))
  if valid_579776 != nil:
    section.add "pp", valid_579776
  var valid_579777 = query.getOrDefault("prettyPrint")
  valid_579777 = validateParameter(valid_579777, JBool, required = false,
                                 default = newJBool(true))
  if valid_579777 != nil:
    section.add "prettyPrint", valid_579777
  var valid_579778 = query.getOrDefault("oauth_token")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "oauth_token", valid_579778
  var valid_579779 = query.getOrDefault("$.xgafv")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = newJString("1"))
  if valid_579779 != nil:
    section.add "$.xgafv", valid_579779
  var valid_579780 = query.getOrDefault("bearer_token")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "bearer_token", valid_579780
  var valid_579781 = query.getOrDefault("alt")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = newJString("json"))
  if valid_579781 != nil:
    section.add "alt", valid_579781
  var valid_579782 = query.getOrDefault("uploadType")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "uploadType", valid_579782
  var valid_579783 = query.getOrDefault("quotaUser")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "quotaUser", valid_579783
  var valid_579784 = query.getOrDefault("callback")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "callback", valid_579784
  var valid_579785 = query.getOrDefault("fields")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "fields", valid_579785
  var valid_579786 = query.getOrDefault("access_token")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "access_token", valid_579786
  var valid_579787 = query.getOrDefault("upload_protocol")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "upload_protocol", valid_579787
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

proc call*(call_579789: Call_ContainerProjectsLocationsClustersSetAddons_579771;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons of a specific cluster.
  ## 
  let valid = call_579789.validator(path, query, header, formData, body)
  let scheme = call_579789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579789.url(scheme.get, call_579789.host, call_579789.base,
                         call_579789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579789, url, valid)

proc call*(call_579790: Call_ContainerProjectsLocationsClustersSetAddons_579771;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetAddons
  ## Sets the addons of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579791 = newJObject()
  var query_579792 = newJObject()
  var body_579793 = newJObject()
  add(query_579792, "key", newJString(key))
  add(query_579792, "pp", newJBool(pp))
  add(query_579792, "prettyPrint", newJBool(prettyPrint))
  add(query_579792, "oauth_token", newJString(oauthToken))
  add(query_579792, "$.xgafv", newJString(Xgafv))
  add(query_579792, "bearer_token", newJString(bearerToken))
  add(query_579792, "alt", newJString(alt))
  add(query_579792, "uploadType", newJString(uploadType))
  add(query_579792, "quotaUser", newJString(quotaUser))
  add(path_579791, "name", newJString(name))
  if body != nil:
    body_579793 = body
  add(query_579792, "callback", newJString(callback))
  add(query_579792, "fields", newJString(fields))
  add(query_579792, "access_token", newJString(accessToken))
  add(query_579792, "upload_protocol", newJString(uploadProtocol))
  result = call_579790.call(path_579791, query_579792, nil, nil, body_579793)

var containerProjectsLocationsClustersSetAddons* = Call_ContainerProjectsLocationsClustersSetAddons_579771(
    name: "containerProjectsLocationsClustersSetAddons",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setAddons",
    validator: validate_ContainerProjectsLocationsClustersSetAddons_579772,
    base: "/", url: url_ContainerProjectsLocationsClustersSetAddons_579773,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579794 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579796(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579795(
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
  var valid_579797 = path.getOrDefault("name")
  valid_579797 = validateParameter(valid_579797, JString, required = true,
                                 default = nil)
  if valid_579797 != nil:
    section.add "name", valid_579797
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579798 = query.getOrDefault("key")
  valid_579798 = validateParameter(valid_579798, JString, required = false,
                                 default = nil)
  if valid_579798 != nil:
    section.add "key", valid_579798
  var valid_579799 = query.getOrDefault("pp")
  valid_579799 = validateParameter(valid_579799, JBool, required = false,
                                 default = newJBool(true))
  if valid_579799 != nil:
    section.add "pp", valid_579799
  var valid_579800 = query.getOrDefault("prettyPrint")
  valid_579800 = validateParameter(valid_579800, JBool, required = false,
                                 default = newJBool(true))
  if valid_579800 != nil:
    section.add "prettyPrint", valid_579800
  var valid_579801 = query.getOrDefault("oauth_token")
  valid_579801 = validateParameter(valid_579801, JString, required = false,
                                 default = nil)
  if valid_579801 != nil:
    section.add "oauth_token", valid_579801
  var valid_579802 = query.getOrDefault("$.xgafv")
  valid_579802 = validateParameter(valid_579802, JString, required = false,
                                 default = newJString("1"))
  if valid_579802 != nil:
    section.add "$.xgafv", valid_579802
  var valid_579803 = query.getOrDefault("bearer_token")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "bearer_token", valid_579803
  var valid_579804 = query.getOrDefault("alt")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = newJString("json"))
  if valid_579804 != nil:
    section.add "alt", valid_579804
  var valid_579805 = query.getOrDefault("uploadType")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "uploadType", valid_579805
  var valid_579806 = query.getOrDefault("quotaUser")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "quotaUser", valid_579806
  var valid_579807 = query.getOrDefault("callback")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "callback", valid_579807
  var valid_579808 = query.getOrDefault("fields")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "fields", valid_579808
  var valid_579809 = query.getOrDefault("access_token")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "access_token", valid_579809
  var valid_579810 = query.getOrDefault("upload_protocol")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "upload_protocol", valid_579810
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

proc call*(call_579812: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579794;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings of a specific node pool.
  ## 
  let valid = call_579812.validator(path, query, header, formData, body)
  let scheme = call_579812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579812.url(scheme.get, call_579812.host, call_579812.base,
                         call_579812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579812, url, valid)

proc call*(call_579813: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579794;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetAutoscaling
  ## Sets the autoscaling settings of a specific node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579814 = newJObject()
  var query_579815 = newJObject()
  var body_579816 = newJObject()
  add(query_579815, "key", newJString(key))
  add(query_579815, "pp", newJBool(pp))
  add(query_579815, "prettyPrint", newJBool(prettyPrint))
  add(query_579815, "oauth_token", newJString(oauthToken))
  add(query_579815, "$.xgafv", newJString(Xgafv))
  add(query_579815, "bearer_token", newJString(bearerToken))
  add(query_579815, "alt", newJString(alt))
  add(query_579815, "uploadType", newJString(uploadType))
  add(query_579815, "quotaUser", newJString(quotaUser))
  add(path_579814, "name", newJString(name))
  if body != nil:
    body_579816 = body
  add(query_579815, "callback", newJString(callback))
  add(query_579815, "fields", newJString(fields))
  add(query_579815, "access_token", newJString(accessToken))
  add(query_579815, "upload_protocol", newJString(uploadProtocol))
  result = call_579813.call(path_579814, query_579815, nil, nil, body_579816)

var containerProjectsLocationsClustersNodePoolsSetAutoscaling* = Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579794(
    name: "containerProjectsLocationsClustersNodePoolsSetAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setAutoscaling", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579795,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_579796,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLegacyAbac_579817 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetLegacyAbac_579819(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetLegacyAbac_579818(
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
  var valid_579820 = path.getOrDefault("name")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "name", valid_579820
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579821 = query.getOrDefault("key")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "key", valid_579821
  var valid_579822 = query.getOrDefault("pp")
  valid_579822 = validateParameter(valid_579822, JBool, required = false,
                                 default = newJBool(true))
  if valid_579822 != nil:
    section.add "pp", valid_579822
  var valid_579823 = query.getOrDefault("prettyPrint")
  valid_579823 = validateParameter(valid_579823, JBool, required = false,
                                 default = newJBool(true))
  if valid_579823 != nil:
    section.add "prettyPrint", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("$.xgafv")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = newJString("1"))
  if valid_579825 != nil:
    section.add "$.xgafv", valid_579825
  var valid_579826 = query.getOrDefault("bearer_token")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "bearer_token", valid_579826
  var valid_579827 = query.getOrDefault("alt")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = newJString("json"))
  if valid_579827 != nil:
    section.add "alt", valid_579827
  var valid_579828 = query.getOrDefault("uploadType")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "uploadType", valid_579828
  var valid_579829 = query.getOrDefault("quotaUser")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "quotaUser", valid_579829
  var valid_579830 = query.getOrDefault("callback")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "callback", valid_579830
  var valid_579831 = query.getOrDefault("fields")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "fields", valid_579831
  var valid_579832 = query.getOrDefault("access_token")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = nil)
  if valid_579832 != nil:
    section.add "access_token", valid_579832
  var valid_579833 = query.getOrDefault("upload_protocol")
  valid_579833 = validateParameter(valid_579833, JString, required = false,
                                 default = nil)
  if valid_579833 != nil:
    section.add "upload_protocol", valid_579833
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

proc call*(call_579835: Call_ContainerProjectsLocationsClustersSetLegacyAbac_579817;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_579835.validator(path, query, header, formData, body)
  let scheme = call_579835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579835.url(scheme.get, call_579835.host, call_579835.base,
                         call_579835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579835, url, valid)

proc call*(call_579836: Call_ContainerProjectsLocationsClustersSetLegacyAbac_579817;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLegacyAbac
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579837 = newJObject()
  var query_579838 = newJObject()
  var body_579839 = newJObject()
  add(query_579838, "key", newJString(key))
  add(query_579838, "pp", newJBool(pp))
  add(query_579838, "prettyPrint", newJBool(prettyPrint))
  add(query_579838, "oauth_token", newJString(oauthToken))
  add(query_579838, "$.xgafv", newJString(Xgafv))
  add(query_579838, "bearer_token", newJString(bearerToken))
  add(query_579838, "alt", newJString(alt))
  add(query_579838, "uploadType", newJString(uploadType))
  add(query_579838, "quotaUser", newJString(quotaUser))
  add(path_579837, "name", newJString(name))
  if body != nil:
    body_579839 = body
  add(query_579838, "callback", newJString(callback))
  add(query_579838, "fields", newJString(fields))
  add(query_579838, "access_token", newJString(accessToken))
  add(query_579838, "upload_protocol", newJString(uploadProtocol))
  result = call_579836.call(path_579837, query_579838, nil, nil, body_579839)

var containerProjectsLocationsClustersSetLegacyAbac* = Call_ContainerProjectsLocationsClustersSetLegacyAbac_579817(
    name: "containerProjectsLocationsClustersSetLegacyAbac",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLegacyAbac",
    validator: validate_ContainerProjectsLocationsClustersSetLegacyAbac_579818,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLegacyAbac_579819,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLocations_579840 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetLocations_579842(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetLocations_579841(
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
  var valid_579843 = path.getOrDefault("name")
  valid_579843 = validateParameter(valid_579843, JString, required = true,
                                 default = nil)
  if valid_579843 != nil:
    section.add "name", valid_579843
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579844 = query.getOrDefault("key")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "key", valid_579844
  var valid_579845 = query.getOrDefault("pp")
  valid_579845 = validateParameter(valid_579845, JBool, required = false,
                                 default = newJBool(true))
  if valid_579845 != nil:
    section.add "pp", valid_579845
  var valid_579846 = query.getOrDefault("prettyPrint")
  valid_579846 = validateParameter(valid_579846, JBool, required = false,
                                 default = newJBool(true))
  if valid_579846 != nil:
    section.add "prettyPrint", valid_579846
  var valid_579847 = query.getOrDefault("oauth_token")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = nil)
  if valid_579847 != nil:
    section.add "oauth_token", valid_579847
  var valid_579848 = query.getOrDefault("$.xgafv")
  valid_579848 = validateParameter(valid_579848, JString, required = false,
                                 default = newJString("1"))
  if valid_579848 != nil:
    section.add "$.xgafv", valid_579848
  var valid_579849 = query.getOrDefault("bearer_token")
  valid_579849 = validateParameter(valid_579849, JString, required = false,
                                 default = nil)
  if valid_579849 != nil:
    section.add "bearer_token", valid_579849
  var valid_579850 = query.getOrDefault("alt")
  valid_579850 = validateParameter(valid_579850, JString, required = false,
                                 default = newJString("json"))
  if valid_579850 != nil:
    section.add "alt", valid_579850
  var valid_579851 = query.getOrDefault("uploadType")
  valid_579851 = validateParameter(valid_579851, JString, required = false,
                                 default = nil)
  if valid_579851 != nil:
    section.add "uploadType", valid_579851
  var valid_579852 = query.getOrDefault("quotaUser")
  valid_579852 = validateParameter(valid_579852, JString, required = false,
                                 default = nil)
  if valid_579852 != nil:
    section.add "quotaUser", valid_579852
  var valid_579853 = query.getOrDefault("callback")
  valid_579853 = validateParameter(valid_579853, JString, required = false,
                                 default = nil)
  if valid_579853 != nil:
    section.add "callback", valid_579853
  var valid_579854 = query.getOrDefault("fields")
  valid_579854 = validateParameter(valid_579854, JString, required = false,
                                 default = nil)
  if valid_579854 != nil:
    section.add "fields", valid_579854
  var valid_579855 = query.getOrDefault("access_token")
  valid_579855 = validateParameter(valid_579855, JString, required = false,
                                 default = nil)
  if valid_579855 != nil:
    section.add "access_token", valid_579855
  var valid_579856 = query.getOrDefault("upload_protocol")
  valid_579856 = validateParameter(valid_579856, JString, required = false,
                                 default = nil)
  if valid_579856 != nil:
    section.add "upload_protocol", valid_579856
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

proc call*(call_579858: Call_ContainerProjectsLocationsClustersSetLocations_579840;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations of a specific cluster.
  ## 
  let valid = call_579858.validator(path, query, header, formData, body)
  let scheme = call_579858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579858.url(scheme.get, call_579858.host, call_579858.base,
                         call_579858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579858, url, valid)

proc call*(call_579859: Call_ContainerProjectsLocationsClustersSetLocations_579840;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLocations
  ## Sets the locations of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579860 = newJObject()
  var query_579861 = newJObject()
  var body_579862 = newJObject()
  add(query_579861, "key", newJString(key))
  add(query_579861, "pp", newJBool(pp))
  add(query_579861, "prettyPrint", newJBool(prettyPrint))
  add(query_579861, "oauth_token", newJString(oauthToken))
  add(query_579861, "$.xgafv", newJString(Xgafv))
  add(query_579861, "bearer_token", newJString(bearerToken))
  add(query_579861, "alt", newJString(alt))
  add(query_579861, "uploadType", newJString(uploadType))
  add(query_579861, "quotaUser", newJString(quotaUser))
  add(path_579860, "name", newJString(name))
  if body != nil:
    body_579862 = body
  add(query_579861, "callback", newJString(callback))
  add(query_579861, "fields", newJString(fields))
  add(query_579861, "access_token", newJString(accessToken))
  add(query_579861, "upload_protocol", newJString(uploadProtocol))
  result = call_579859.call(path_579860, query_579861, nil, nil, body_579862)

var containerProjectsLocationsClustersSetLocations* = Call_ContainerProjectsLocationsClustersSetLocations_579840(
    name: "containerProjectsLocationsClustersSetLocations",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLocations",
    validator: validate_ContainerProjectsLocationsClustersSetLocations_579841,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLocations_579842,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLogging_579863 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetLogging_579865(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetLogging_579864(path: JsonNode;
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
  var valid_579866 = path.getOrDefault("name")
  valid_579866 = validateParameter(valid_579866, JString, required = true,
                                 default = nil)
  if valid_579866 != nil:
    section.add "name", valid_579866
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579867 = query.getOrDefault("key")
  valid_579867 = validateParameter(valid_579867, JString, required = false,
                                 default = nil)
  if valid_579867 != nil:
    section.add "key", valid_579867
  var valid_579868 = query.getOrDefault("pp")
  valid_579868 = validateParameter(valid_579868, JBool, required = false,
                                 default = newJBool(true))
  if valid_579868 != nil:
    section.add "pp", valid_579868
  var valid_579869 = query.getOrDefault("prettyPrint")
  valid_579869 = validateParameter(valid_579869, JBool, required = false,
                                 default = newJBool(true))
  if valid_579869 != nil:
    section.add "prettyPrint", valid_579869
  var valid_579870 = query.getOrDefault("oauth_token")
  valid_579870 = validateParameter(valid_579870, JString, required = false,
                                 default = nil)
  if valid_579870 != nil:
    section.add "oauth_token", valid_579870
  var valid_579871 = query.getOrDefault("$.xgafv")
  valid_579871 = validateParameter(valid_579871, JString, required = false,
                                 default = newJString("1"))
  if valid_579871 != nil:
    section.add "$.xgafv", valid_579871
  var valid_579872 = query.getOrDefault("bearer_token")
  valid_579872 = validateParameter(valid_579872, JString, required = false,
                                 default = nil)
  if valid_579872 != nil:
    section.add "bearer_token", valid_579872
  var valid_579873 = query.getOrDefault("alt")
  valid_579873 = validateParameter(valid_579873, JString, required = false,
                                 default = newJString("json"))
  if valid_579873 != nil:
    section.add "alt", valid_579873
  var valid_579874 = query.getOrDefault("uploadType")
  valid_579874 = validateParameter(valid_579874, JString, required = false,
                                 default = nil)
  if valid_579874 != nil:
    section.add "uploadType", valid_579874
  var valid_579875 = query.getOrDefault("quotaUser")
  valid_579875 = validateParameter(valid_579875, JString, required = false,
                                 default = nil)
  if valid_579875 != nil:
    section.add "quotaUser", valid_579875
  var valid_579876 = query.getOrDefault("callback")
  valid_579876 = validateParameter(valid_579876, JString, required = false,
                                 default = nil)
  if valid_579876 != nil:
    section.add "callback", valid_579876
  var valid_579877 = query.getOrDefault("fields")
  valid_579877 = validateParameter(valid_579877, JString, required = false,
                                 default = nil)
  if valid_579877 != nil:
    section.add "fields", valid_579877
  var valid_579878 = query.getOrDefault("access_token")
  valid_579878 = validateParameter(valid_579878, JString, required = false,
                                 default = nil)
  if valid_579878 != nil:
    section.add "access_token", valid_579878
  var valid_579879 = query.getOrDefault("upload_protocol")
  valid_579879 = validateParameter(valid_579879, JString, required = false,
                                 default = nil)
  if valid_579879 != nil:
    section.add "upload_protocol", valid_579879
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

proc call*(call_579881: Call_ContainerProjectsLocationsClustersSetLogging_579863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service of a specific cluster.
  ## 
  let valid = call_579881.validator(path, query, header, formData, body)
  let scheme = call_579881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579881.url(scheme.get, call_579881.host, call_579881.base,
                         call_579881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579881, url, valid)

proc call*(call_579882: Call_ContainerProjectsLocationsClustersSetLogging_579863;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetLogging
  ## Sets the logging service of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579883 = newJObject()
  var query_579884 = newJObject()
  var body_579885 = newJObject()
  add(query_579884, "key", newJString(key))
  add(query_579884, "pp", newJBool(pp))
  add(query_579884, "prettyPrint", newJBool(prettyPrint))
  add(query_579884, "oauth_token", newJString(oauthToken))
  add(query_579884, "$.xgafv", newJString(Xgafv))
  add(query_579884, "bearer_token", newJString(bearerToken))
  add(query_579884, "alt", newJString(alt))
  add(query_579884, "uploadType", newJString(uploadType))
  add(query_579884, "quotaUser", newJString(quotaUser))
  add(path_579883, "name", newJString(name))
  if body != nil:
    body_579885 = body
  add(query_579884, "callback", newJString(callback))
  add(query_579884, "fields", newJString(fields))
  add(query_579884, "access_token", newJString(accessToken))
  add(query_579884, "upload_protocol", newJString(uploadProtocol))
  result = call_579882.call(path_579883, query_579884, nil, nil, body_579885)

var containerProjectsLocationsClustersSetLogging* = Call_ContainerProjectsLocationsClustersSetLogging_579863(
    name: "containerProjectsLocationsClustersSetLogging",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setLogging",
    validator: validate_ContainerProjectsLocationsClustersSetLogging_579864,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLogging_579865,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_579886 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetMaintenancePolicy_579888(
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

proc validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_579887(
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
  var valid_579889 = path.getOrDefault("name")
  valid_579889 = validateParameter(valid_579889, JString, required = true,
                                 default = nil)
  if valid_579889 != nil:
    section.add "name", valid_579889
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579890 = query.getOrDefault("key")
  valid_579890 = validateParameter(valid_579890, JString, required = false,
                                 default = nil)
  if valid_579890 != nil:
    section.add "key", valid_579890
  var valid_579891 = query.getOrDefault("pp")
  valid_579891 = validateParameter(valid_579891, JBool, required = false,
                                 default = newJBool(true))
  if valid_579891 != nil:
    section.add "pp", valid_579891
  var valid_579892 = query.getOrDefault("prettyPrint")
  valid_579892 = validateParameter(valid_579892, JBool, required = false,
                                 default = newJBool(true))
  if valid_579892 != nil:
    section.add "prettyPrint", valid_579892
  var valid_579893 = query.getOrDefault("oauth_token")
  valid_579893 = validateParameter(valid_579893, JString, required = false,
                                 default = nil)
  if valid_579893 != nil:
    section.add "oauth_token", valid_579893
  var valid_579894 = query.getOrDefault("$.xgafv")
  valid_579894 = validateParameter(valid_579894, JString, required = false,
                                 default = newJString("1"))
  if valid_579894 != nil:
    section.add "$.xgafv", valid_579894
  var valid_579895 = query.getOrDefault("bearer_token")
  valid_579895 = validateParameter(valid_579895, JString, required = false,
                                 default = nil)
  if valid_579895 != nil:
    section.add "bearer_token", valid_579895
  var valid_579896 = query.getOrDefault("alt")
  valid_579896 = validateParameter(valid_579896, JString, required = false,
                                 default = newJString("json"))
  if valid_579896 != nil:
    section.add "alt", valid_579896
  var valid_579897 = query.getOrDefault("uploadType")
  valid_579897 = validateParameter(valid_579897, JString, required = false,
                                 default = nil)
  if valid_579897 != nil:
    section.add "uploadType", valid_579897
  var valid_579898 = query.getOrDefault("quotaUser")
  valid_579898 = validateParameter(valid_579898, JString, required = false,
                                 default = nil)
  if valid_579898 != nil:
    section.add "quotaUser", valid_579898
  var valid_579899 = query.getOrDefault("callback")
  valid_579899 = validateParameter(valid_579899, JString, required = false,
                                 default = nil)
  if valid_579899 != nil:
    section.add "callback", valid_579899
  var valid_579900 = query.getOrDefault("fields")
  valid_579900 = validateParameter(valid_579900, JString, required = false,
                                 default = nil)
  if valid_579900 != nil:
    section.add "fields", valid_579900
  var valid_579901 = query.getOrDefault("access_token")
  valid_579901 = validateParameter(valid_579901, JString, required = false,
                                 default = nil)
  if valid_579901 != nil:
    section.add "access_token", valid_579901
  var valid_579902 = query.getOrDefault("upload_protocol")
  valid_579902 = validateParameter(valid_579902, JString, required = false,
                                 default = nil)
  if valid_579902 != nil:
    section.add "upload_protocol", valid_579902
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

proc call*(call_579904: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_579886;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_579904.validator(path, query, header, formData, body)
  let scheme = call_579904.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579904.url(scheme.get, call_579904.host, call_579904.base,
                         call_579904.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579904, url, valid)

proc call*(call_579905: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_579886;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMaintenancePolicy
  ## Sets the maintenance policy for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579906 = newJObject()
  var query_579907 = newJObject()
  var body_579908 = newJObject()
  add(query_579907, "key", newJString(key))
  add(query_579907, "pp", newJBool(pp))
  add(query_579907, "prettyPrint", newJBool(prettyPrint))
  add(query_579907, "oauth_token", newJString(oauthToken))
  add(query_579907, "$.xgafv", newJString(Xgafv))
  add(query_579907, "bearer_token", newJString(bearerToken))
  add(query_579907, "alt", newJString(alt))
  add(query_579907, "uploadType", newJString(uploadType))
  add(query_579907, "quotaUser", newJString(quotaUser))
  add(path_579906, "name", newJString(name))
  if body != nil:
    body_579908 = body
  add(query_579907, "callback", newJString(callback))
  add(query_579907, "fields", newJString(fields))
  add(query_579907, "access_token", newJString(accessToken))
  add(query_579907, "upload_protocol", newJString(uploadProtocol))
  result = call_579905.call(path_579906, query_579907, nil, nil, body_579908)

var containerProjectsLocationsClustersSetMaintenancePolicy* = Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_579886(
    name: "containerProjectsLocationsClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMaintenancePolicy",
    validator: validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_579887,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMaintenancePolicy_579888,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_579909 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsSetManagement_579911(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_579910(
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
  var valid_579912 = path.getOrDefault("name")
  valid_579912 = validateParameter(valid_579912, JString, required = true,
                                 default = nil)
  if valid_579912 != nil:
    section.add "name", valid_579912
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579913 = query.getOrDefault("key")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = nil)
  if valid_579913 != nil:
    section.add "key", valid_579913
  var valid_579914 = query.getOrDefault("pp")
  valid_579914 = validateParameter(valid_579914, JBool, required = false,
                                 default = newJBool(true))
  if valid_579914 != nil:
    section.add "pp", valid_579914
  var valid_579915 = query.getOrDefault("prettyPrint")
  valid_579915 = validateParameter(valid_579915, JBool, required = false,
                                 default = newJBool(true))
  if valid_579915 != nil:
    section.add "prettyPrint", valid_579915
  var valid_579916 = query.getOrDefault("oauth_token")
  valid_579916 = validateParameter(valid_579916, JString, required = false,
                                 default = nil)
  if valid_579916 != nil:
    section.add "oauth_token", valid_579916
  var valid_579917 = query.getOrDefault("$.xgafv")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = newJString("1"))
  if valid_579917 != nil:
    section.add "$.xgafv", valid_579917
  var valid_579918 = query.getOrDefault("bearer_token")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "bearer_token", valid_579918
  var valid_579919 = query.getOrDefault("alt")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = newJString("json"))
  if valid_579919 != nil:
    section.add "alt", valid_579919
  var valid_579920 = query.getOrDefault("uploadType")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = nil)
  if valid_579920 != nil:
    section.add "uploadType", valid_579920
  var valid_579921 = query.getOrDefault("quotaUser")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "quotaUser", valid_579921
  var valid_579922 = query.getOrDefault("callback")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "callback", valid_579922
  var valid_579923 = query.getOrDefault("fields")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "fields", valid_579923
  var valid_579924 = query.getOrDefault("access_token")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "access_token", valid_579924
  var valid_579925 = query.getOrDefault("upload_protocol")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = nil)
  if valid_579925 != nil:
    section.add "upload_protocol", valid_579925
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

proc call*(call_579927: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_579909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_579927.validator(path, query, header, formData, body)
  let scheme = call_579927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579927.url(scheme.get, call_579927.host, call_579927.base,
                         call_579927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579927, url, valid)

proc call*(call_579928: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_579909;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsSetManagement
  ## Sets the NodeManagement options for a node pool.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579929 = newJObject()
  var query_579930 = newJObject()
  var body_579931 = newJObject()
  add(query_579930, "key", newJString(key))
  add(query_579930, "pp", newJBool(pp))
  add(query_579930, "prettyPrint", newJBool(prettyPrint))
  add(query_579930, "oauth_token", newJString(oauthToken))
  add(query_579930, "$.xgafv", newJString(Xgafv))
  add(query_579930, "bearer_token", newJString(bearerToken))
  add(query_579930, "alt", newJString(alt))
  add(query_579930, "uploadType", newJString(uploadType))
  add(query_579930, "quotaUser", newJString(quotaUser))
  add(path_579929, "name", newJString(name))
  if body != nil:
    body_579931 = body
  add(query_579930, "callback", newJString(callback))
  add(query_579930, "fields", newJString(fields))
  add(query_579930, "access_token", newJString(accessToken))
  add(query_579930, "upload_protocol", newJString(uploadProtocol))
  result = call_579928.call(path_579929, query_579930, nil, nil, body_579931)

var containerProjectsLocationsClustersNodePoolsSetManagement* = Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_579909(
    name: "containerProjectsLocationsClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setManagement", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_579910,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetManagement_579911,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMasterAuth_579932 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetMasterAuth_579934(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetMasterAuth_579933(
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
  var valid_579935 = path.getOrDefault("name")
  valid_579935 = validateParameter(valid_579935, JString, required = true,
                                 default = nil)
  if valid_579935 != nil:
    section.add "name", valid_579935
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579936 = query.getOrDefault("key")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "key", valid_579936
  var valid_579937 = query.getOrDefault("pp")
  valid_579937 = validateParameter(valid_579937, JBool, required = false,
                                 default = newJBool(true))
  if valid_579937 != nil:
    section.add "pp", valid_579937
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
  var valid_579941 = query.getOrDefault("bearer_token")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "bearer_token", valid_579941
  var valid_579942 = query.getOrDefault("alt")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = newJString("json"))
  if valid_579942 != nil:
    section.add "alt", valid_579942
  var valid_579943 = query.getOrDefault("uploadType")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "uploadType", valid_579943
  var valid_579944 = query.getOrDefault("quotaUser")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "quotaUser", valid_579944
  var valid_579945 = query.getOrDefault("callback")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "callback", valid_579945
  var valid_579946 = query.getOrDefault("fields")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "fields", valid_579946
  var valid_579947 = query.getOrDefault("access_token")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "access_token", valid_579947
  var valid_579948 = query.getOrDefault("upload_protocol")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "upload_protocol", valid_579948
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

proc call*(call_579950: Call_ContainerProjectsLocationsClustersSetMasterAuth_579932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ## 
  let valid = call_579950.validator(path, query, header, formData, body)
  let scheme = call_579950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579950.url(scheme.get, call_579950.host, call_579950.base,
                         call_579950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579950, url, valid)

proc call*(call_579951: Call_ContainerProjectsLocationsClustersSetMasterAuth_579932;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMasterAuth
  ## Used to set master auth materials. Currently supports :-
  ## Changing the admin password of a specific cluster.
  ## This can be either via password generation or explicitly set.
  ## Modify basic_auth.csv and reset the K8S API server.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579952 = newJObject()
  var query_579953 = newJObject()
  var body_579954 = newJObject()
  add(query_579953, "key", newJString(key))
  add(query_579953, "pp", newJBool(pp))
  add(query_579953, "prettyPrint", newJBool(prettyPrint))
  add(query_579953, "oauth_token", newJString(oauthToken))
  add(query_579953, "$.xgafv", newJString(Xgafv))
  add(query_579953, "bearer_token", newJString(bearerToken))
  add(query_579953, "alt", newJString(alt))
  add(query_579953, "uploadType", newJString(uploadType))
  add(query_579953, "quotaUser", newJString(quotaUser))
  add(path_579952, "name", newJString(name))
  if body != nil:
    body_579954 = body
  add(query_579953, "callback", newJString(callback))
  add(query_579953, "fields", newJString(fields))
  add(query_579953, "access_token", newJString(accessToken))
  add(query_579953, "upload_protocol", newJString(uploadProtocol))
  result = call_579951.call(path_579952, query_579953, nil, nil, body_579954)

var containerProjectsLocationsClustersSetMasterAuth* = Call_ContainerProjectsLocationsClustersSetMasterAuth_579932(
    name: "containerProjectsLocationsClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMasterAuth",
    validator: validate_ContainerProjectsLocationsClustersSetMasterAuth_579933,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMasterAuth_579934,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMonitoring_579955 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetMonitoring_579957(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetMonitoring_579956(
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
  var valid_579958 = path.getOrDefault("name")
  valid_579958 = validateParameter(valid_579958, JString, required = true,
                                 default = nil)
  if valid_579958 != nil:
    section.add "name", valid_579958
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579959 = query.getOrDefault("key")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "key", valid_579959
  var valid_579960 = query.getOrDefault("pp")
  valid_579960 = validateParameter(valid_579960, JBool, required = false,
                                 default = newJBool(true))
  if valid_579960 != nil:
    section.add "pp", valid_579960
  var valid_579961 = query.getOrDefault("prettyPrint")
  valid_579961 = validateParameter(valid_579961, JBool, required = false,
                                 default = newJBool(true))
  if valid_579961 != nil:
    section.add "prettyPrint", valid_579961
  var valid_579962 = query.getOrDefault("oauth_token")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "oauth_token", valid_579962
  var valid_579963 = query.getOrDefault("$.xgafv")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("1"))
  if valid_579963 != nil:
    section.add "$.xgafv", valid_579963
  var valid_579964 = query.getOrDefault("bearer_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "bearer_token", valid_579964
  var valid_579965 = query.getOrDefault("alt")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("json"))
  if valid_579965 != nil:
    section.add "alt", valid_579965
  var valid_579966 = query.getOrDefault("uploadType")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "uploadType", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("callback")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "callback", valid_579968
  var valid_579969 = query.getOrDefault("fields")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "fields", valid_579969
  var valid_579970 = query.getOrDefault("access_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "access_token", valid_579970
  var valid_579971 = query.getOrDefault("upload_protocol")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "upload_protocol", valid_579971
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

proc call*(call_579973: Call_ContainerProjectsLocationsClustersSetMonitoring_579955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service of a specific cluster.
  ## 
  let valid = call_579973.validator(path, query, header, formData, body)
  let scheme = call_579973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579973.url(scheme.get, call_579973.host, call_579973.base,
                         call_579973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579973, url, valid)

proc call*(call_579974: Call_ContainerProjectsLocationsClustersSetMonitoring_579955;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetMonitoring
  ## Sets the monitoring service of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_579975 = newJObject()
  var query_579976 = newJObject()
  var body_579977 = newJObject()
  add(query_579976, "key", newJString(key))
  add(query_579976, "pp", newJBool(pp))
  add(query_579976, "prettyPrint", newJBool(prettyPrint))
  add(query_579976, "oauth_token", newJString(oauthToken))
  add(query_579976, "$.xgafv", newJString(Xgafv))
  add(query_579976, "bearer_token", newJString(bearerToken))
  add(query_579976, "alt", newJString(alt))
  add(query_579976, "uploadType", newJString(uploadType))
  add(query_579976, "quotaUser", newJString(quotaUser))
  add(path_579975, "name", newJString(name))
  if body != nil:
    body_579977 = body
  add(query_579976, "callback", newJString(callback))
  add(query_579976, "fields", newJString(fields))
  add(query_579976, "access_token", newJString(accessToken))
  add(query_579976, "upload_protocol", newJString(uploadProtocol))
  result = call_579974.call(path_579975, query_579976, nil, nil, body_579977)

var containerProjectsLocationsClustersSetMonitoring* = Call_ContainerProjectsLocationsClustersSetMonitoring_579955(
    name: "containerProjectsLocationsClustersSetMonitoring",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setMonitoring",
    validator: validate_ContainerProjectsLocationsClustersSetMonitoring_579956,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMonitoring_579957,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetNetworkPolicy_579978 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetNetworkPolicy_579980(
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

proc validate_ContainerProjectsLocationsClustersSetNetworkPolicy_579979(
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
  var valid_579981 = path.getOrDefault("name")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "name", valid_579981
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579982 = query.getOrDefault("key")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "key", valid_579982
  var valid_579983 = query.getOrDefault("pp")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(true))
  if valid_579983 != nil:
    section.add "pp", valid_579983
  var valid_579984 = query.getOrDefault("prettyPrint")
  valid_579984 = validateParameter(valid_579984, JBool, required = false,
                                 default = newJBool(true))
  if valid_579984 != nil:
    section.add "prettyPrint", valid_579984
  var valid_579985 = query.getOrDefault("oauth_token")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "oauth_token", valid_579985
  var valid_579986 = query.getOrDefault("$.xgafv")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("1"))
  if valid_579986 != nil:
    section.add "$.xgafv", valid_579986
  var valid_579987 = query.getOrDefault("bearer_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "bearer_token", valid_579987
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

proc call*(call_579996: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_579978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables/Disables Network Policy for a cluster.
  ## 
  let valid = call_579996.validator(path, query, header, formData, body)
  let scheme = call_579996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579996.url(scheme.get, call_579996.host, call_579996.base,
                         call_579996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579996, url, valid)

proc call*(call_579997: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_579978;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetNetworkPolicy
  ## Enables/Disables Network Policy for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to set networking policy.
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
  var path_579998 = newJObject()
  var query_579999 = newJObject()
  var body_580000 = newJObject()
  add(query_579999, "key", newJString(key))
  add(query_579999, "pp", newJBool(pp))
  add(query_579999, "prettyPrint", newJBool(prettyPrint))
  add(query_579999, "oauth_token", newJString(oauthToken))
  add(query_579999, "$.xgafv", newJString(Xgafv))
  add(query_579999, "bearer_token", newJString(bearerToken))
  add(query_579999, "alt", newJString(alt))
  add(query_579999, "uploadType", newJString(uploadType))
  add(query_579999, "quotaUser", newJString(quotaUser))
  add(path_579998, "name", newJString(name))
  if body != nil:
    body_580000 = body
  add(query_579999, "callback", newJString(callback))
  add(query_579999, "fields", newJString(fields))
  add(query_579999, "access_token", newJString(accessToken))
  add(query_579999, "upload_protocol", newJString(uploadProtocol))
  result = call_579997.call(path_579998, query_579999, nil, nil, body_580000)

var containerProjectsLocationsClustersSetNetworkPolicy* = Call_ContainerProjectsLocationsClustersSetNetworkPolicy_579978(
    name: "containerProjectsLocationsClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setNetworkPolicy",
    validator: validate_ContainerProjectsLocationsClustersSetNetworkPolicy_579979,
    base: "/", url: url_ContainerProjectsLocationsClustersSetNetworkPolicy_579980,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetResourceLabels_580001 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersSetResourceLabels_580003(
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

proc validate_ContainerProjectsLocationsClustersSetResourceLabels_580002(
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
  var valid_580004 = path.getOrDefault("name")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "name", valid_580004
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_580005 = query.getOrDefault("key")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "key", valid_580005
  var valid_580006 = query.getOrDefault("pp")
  valid_580006 = validateParameter(valid_580006, JBool, required = false,
                                 default = newJBool(true))
  if valid_580006 != nil:
    section.add "pp", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("$.xgafv")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("1"))
  if valid_580009 != nil:
    section.add "$.xgafv", valid_580009
  var valid_580010 = query.getOrDefault("bearer_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "bearer_token", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("callback")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "callback", valid_580014
  var valid_580015 = query.getOrDefault("fields")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "fields", valid_580015
  var valid_580016 = query.getOrDefault("access_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "access_token", valid_580016
  var valid_580017 = query.getOrDefault("upload_protocol")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "upload_protocol", valid_580017
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

proc call*(call_580019: Call_ContainerProjectsLocationsClustersSetResourceLabels_580001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_ContainerProjectsLocationsClustersSetResourceLabels_580001;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersSetResourceLabels
  ## Sets labels on a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  var body_580023 = newJObject()
  add(query_580022, "key", newJString(key))
  add(query_580022, "pp", newJBool(pp))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "$.xgafv", newJString(Xgafv))
  add(query_580022, "bearer_token", newJString(bearerToken))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "uploadType", newJString(uploadType))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(path_580021, "name", newJString(name))
  if body != nil:
    body_580023 = body
  add(query_580022, "callback", newJString(callback))
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "access_token", newJString(accessToken))
  add(query_580022, "upload_protocol", newJString(uploadProtocol))
  result = call_580020.call(path_580021, query_580022, nil, nil, body_580023)

var containerProjectsLocationsClustersSetResourceLabels* = Call_ContainerProjectsLocationsClustersSetResourceLabels_580001(
    name: "containerProjectsLocationsClustersSetResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:setResourceLabels",
    validator: validate_ContainerProjectsLocationsClustersSetResourceLabels_580002,
    base: "/", url: url_ContainerProjectsLocationsClustersSetResourceLabels_580003,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersStartIpRotation_580024 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersStartIpRotation_580026(
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

proc validate_ContainerProjectsLocationsClustersStartIpRotation_580025(
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
  var valid_580027 = path.getOrDefault("name")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "name", valid_580027
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_580028 = query.getOrDefault("key")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "key", valid_580028
  var valid_580029 = query.getOrDefault("pp")
  valid_580029 = validateParameter(valid_580029, JBool, required = false,
                                 default = newJBool(true))
  if valid_580029 != nil:
    section.add "pp", valid_580029
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
  var valid_580033 = query.getOrDefault("bearer_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "bearer_token", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("uploadType")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "uploadType", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("callback")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "callback", valid_580037
  var valid_580038 = query.getOrDefault("fields")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "fields", valid_580038
  var valid_580039 = query.getOrDefault("access_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "access_token", valid_580039
  var valid_580040 = query.getOrDefault("upload_protocol")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "upload_protocol", valid_580040
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

proc call*(call_580042: Call_ContainerProjectsLocationsClustersStartIpRotation_580024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start master IP rotation.
  ## 
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_ContainerProjectsLocationsClustersStartIpRotation_580024;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersStartIpRotation
  ## Start master IP rotation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name (project, location, cluster id) of the cluster to start IP rotation.
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
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  var body_580046 = newJObject()
  add(query_580045, "key", newJString(key))
  add(query_580045, "pp", newJBool(pp))
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "$.xgafv", newJString(Xgafv))
  add(query_580045, "bearer_token", newJString(bearerToken))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "uploadType", newJString(uploadType))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(path_580044, "name", newJString(name))
  if body != nil:
    body_580046 = body
  add(query_580045, "callback", newJString(callback))
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "access_token", newJString(accessToken))
  add(query_580045, "upload_protocol", newJString(uploadProtocol))
  result = call_580043.call(path_580044, query_580045, nil, nil, body_580046)

var containerProjectsLocationsClustersStartIpRotation* = Call_ContainerProjectsLocationsClustersStartIpRotation_580024(
    name: "containerProjectsLocationsClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:startIpRotation",
    validator: validate_ContainerProjectsLocationsClustersStartIpRotation_580025,
    base: "/", url: url_ContainerProjectsLocationsClustersStartIpRotation_580026,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersUpdateMaster_580047 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersUpdateMaster_580049(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersUpdateMaster_580048(
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
  var valid_580050 = path.getOrDefault("name")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "name", valid_580050
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("pp")
  valid_580052 = validateParameter(valid_580052, JBool, required = false,
                                 default = newJBool(true))
  if valid_580052 != nil:
    section.add "pp", valid_580052
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
  var valid_580056 = query.getOrDefault("bearer_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "bearer_token", valid_580056
  var valid_580057 = query.getOrDefault("alt")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("json"))
  if valid_580057 != nil:
    section.add "alt", valid_580057
  var valid_580058 = query.getOrDefault("uploadType")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "uploadType", valid_580058
  var valid_580059 = query.getOrDefault("quotaUser")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "quotaUser", valid_580059
  var valid_580060 = query.getOrDefault("callback")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "callback", valid_580060
  var valid_580061 = query.getOrDefault("fields")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "fields", valid_580061
  var valid_580062 = query.getOrDefault("access_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "access_token", valid_580062
  var valid_580063 = query.getOrDefault("upload_protocol")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "upload_protocol", valid_580063
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

proc call*(call_580065: Call_ContainerProjectsLocationsClustersUpdateMaster_580047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master of a specific cluster.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_ContainerProjectsLocationsClustersUpdateMaster_580047;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersUpdateMaster
  ## Updates the master of a specific cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  var body_580069 = newJObject()
  add(query_580068, "key", newJString(key))
  add(query_580068, "pp", newJBool(pp))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "$.xgafv", newJString(Xgafv))
  add(query_580068, "bearer_token", newJString(bearerToken))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "uploadType", newJString(uploadType))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(path_580067, "name", newJString(name))
  if body != nil:
    body_580069 = body
  add(query_580068, "callback", newJString(callback))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "access_token", newJString(accessToken))
  add(query_580068, "upload_protocol", newJString(uploadProtocol))
  result = call_580066.call(path_580067, query_580068, nil, nil, body_580069)

var containerProjectsLocationsClustersUpdateMaster* = Call_ContainerProjectsLocationsClustersUpdateMaster_580047(
    name: "containerProjectsLocationsClustersUpdateMaster",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{name}:updateMaster",
    validator: validate_ContainerProjectsLocationsClustersUpdateMaster_580048,
    base: "/", url: url_ContainerProjectsLocationsClustersUpdateMaster_580049,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCreate_580093 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersCreate_580095(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersCreate_580094(path: JsonNode;
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
  var valid_580096 = path.getOrDefault("parent")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "parent", valid_580096
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_580097 = query.getOrDefault("key")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "key", valid_580097
  var valid_580098 = query.getOrDefault("pp")
  valid_580098 = validateParameter(valid_580098, JBool, required = false,
                                 default = newJBool(true))
  if valid_580098 != nil:
    section.add "pp", valid_580098
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
  var valid_580102 = query.getOrDefault("bearer_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "bearer_token", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("uploadType")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "uploadType", valid_580104
  var valid_580105 = query.getOrDefault("quotaUser")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "quotaUser", valid_580105
  var valid_580106 = query.getOrDefault("callback")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "callback", valid_580106
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  var valid_580108 = query.getOrDefault("access_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "access_token", valid_580108
  var valid_580109 = query.getOrDefault("upload_protocol")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "upload_protocol", valid_580109
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

proc call*(call_580111: Call_ContainerProjectsLocationsClustersCreate_580093;
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
  let valid = call_580111.validator(path, query, header, formData, body)
  let scheme = call_580111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580111.url(scheme.get, call_580111.host, call_580111.base,
                         call_580111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580111, url, valid)

proc call*(call_580112: Call_ContainerProjectsLocationsClustersCreate_580093;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  var path_580113 = newJObject()
  var query_580114 = newJObject()
  var body_580115 = newJObject()
  add(query_580114, "key", newJString(key))
  add(query_580114, "pp", newJBool(pp))
  add(query_580114, "prettyPrint", newJBool(prettyPrint))
  add(query_580114, "oauth_token", newJString(oauthToken))
  add(query_580114, "$.xgafv", newJString(Xgafv))
  add(query_580114, "bearer_token", newJString(bearerToken))
  add(query_580114, "alt", newJString(alt))
  add(query_580114, "uploadType", newJString(uploadType))
  add(query_580114, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580115 = body
  add(query_580114, "callback", newJString(callback))
  add(path_580113, "parent", newJString(parent))
  add(query_580114, "fields", newJString(fields))
  add(query_580114, "access_token", newJString(accessToken))
  add(query_580114, "upload_protocol", newJString(uploadProtocol))
  result = call_580112.call(path_580113, query_580114, nil, nil, body_580115)

var containerProjectsLocationsClustersCreate* = Call_ContainerProjectsLocationsClustersCreate_580093(
    name: "containerProjectsLocationsClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersCreate_580094,
    base: "/", url: url_ContainerProjectsLocationsClustersCreate_580095,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersList_580070 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersList_580072(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersList_580071(path: JsonNode;
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
  var valid_580073 = path.getOrDefault("parent")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "parent", valid_580073
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  section = newJObject()
  var valid_580074 = query.getOrDefault("key")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "key", valid_580074
  var valid_580075 = query.getOrDefault("pp")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "pp", valid_580075
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
  var valid_580079 = query.getOrDefault("bearer_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "bearer_token", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("uploadType")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "uploadType", valid_580081
  var valid_580082 = query.getOrDefault("quotaUser")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "quotaUser", valid_580082
  var valid_580083 = query.getOrDefault("zone")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "zone", valid_580083
  var valid_580084 = query.getOrDefault("callback")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "callback", valid_580084
  var valid_580085 = query.getOrDefault("fields")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "fields", valid_580085
  var valid_580086 = query.getOrDefault("access_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "access_token", valid_580086
  var valid_580087 = query.getOrDefault("upload_protocol")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "upload_protocol", valid_580087
  var valid_580088 = query.getOrDefault("projectId")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "projectId", valid_580088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580089: Call_ContainerProjectsLocationsClustersList_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_580089.validator(path, query, header, formData, body)
  let scheme = call_580089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580089.url(scheme.get, call_580089.host, call_580089.base,
                         call_580089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580089, url, valid)

proc call*(call_580090: Call_ContainerProjectsLocationsClustersList_580070;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          zone: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## containerProjectsLocationsClustersList
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides, or "-" for all zones.
  ## This field is deprecated, use parent instead.
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
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  var path_580091 = newJObject()
  var query_580092 = newJObject()
  add(query_580092, "key", newJString(key))
  add(query_580092, "pp", newJBool(pp))
  add(query_580092, "prettyPrint", newJBool(prettyPrint))
  add(query_580092, "oauth_token", newJString(oauthToken))
  add(query_580092, "$.xgafv", newJString(Xgafv))
  add(query_580092, "bearer_token", newJString(bearerToken))
  add(query_580092, "alt", newJString(alt))
  add(query_580092, "uploadType", newJString(uploadType))
  add(query_580092, "quotaUser", newJString(quotaUser))
  add(query_580092, "zone", newJString(zone))
  add(query_580092, "callback", newJString(callback))
  add(path_580091, "parent", newJString(parent))
  add(query_580092, "fields", newJString(fields))
  add(query_580092, "access_token", newJString(accessToken))
  add(query_580092, "upload_protocol", newJString(uploadProtocol))
  add(query_580092, "projectId", newJString(projectId))
  result = call_580090.call(path_580091, query_580092, nil, nil, nil)

var containerProjectsLocationsClustersList* = Call_ContainerProjectsLocationsClustersList_580070(
    name: "containerProjectsLocationsClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersList_580071, base: "/",
    url: url_ContainerProjectsLocationsClustersList_580072,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsCreate_580140 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsCreate_580142(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsCreate_580141(
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
  var valid_580143 = path.getOrDefault("parent")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "parent", valid_580143
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_580145 = query.getOrDefault("pp")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "pp", valid_580145
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
  var valid_580149 = query.getOrDefault("bearer_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "bearer_token", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("uploadType")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "uploadType", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("callback")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "callback", valid_580153
  var valid_580154 = query.getOrDefault("fields")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "fields", valid_580154
  var valid_580155 = query.getOrDefault("access_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "access_token", valid_580155
  var valid_580156 = query.getOrDefault("upload_protocol")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "upload_protocol", valid_580156
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

proc call*(call_580158: Call_ContainerProjectsLocationsClustersNodePoolsCreate_580140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_580158.validator(path, query, header, formData, body)
  let scheme = call_580158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580158.url(scheme.get, call_580158.host, call_580158.base,
                         call_580158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580158, url, valid)

proc call*(call_580159: Call_ContainerProjectsLocationsClustersNodePoolsCreate_580140;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsCreate
  ## Creates a node pool for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
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
  ##         : The parent (project, location, cluster id) where the node pool will be created.
  ## Specified in the format 'projects/*/locations/*/clusters/*/nodePools/*'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580160 = newJObject()
  var query_580161 = newJObject()
  var body_580162 = newJObject()
  add(query_580161, "key", newJString(key))
  add(query_580161, "pp", newJBool(pp))
  add(query_580161, "prettyPrint", newJBool(prettyPrint))
  add(query_580161, "oauth_token", newJString(oauthToken))
  add(query_580161, "$.xgafv", newJString(Xgafv))
  add(query_580161, "bearer_token", newJString(bearerToken))
  add(query_580161, "alt", newJString(alt))
  add(query_580161, "uploadType", newJString(uploadType))
  add(query_580161, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580162 = body
  add(query_580161, "callback", newJString(callback))
  add(path_580160, "parent", newJString(parent))
  add(query_580161, "fields", newJString(fields))
  add(query_580161, "access_token", newJString(accessToken))
  add(query_580161, "upload_protocol", newJString(uploadProtocol))
  result = call_580159.call(path_580160, query_580161, nil, nil, body_580162)

var containerProjectsLocationsClustersNodePoolsCreate* = Call_ContainerProjectsLocationsClustersNodePoolsCreate_580140(
    name: "containerProjectsLocationsClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1beta1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsCreate_580141,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsCreate_580142,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsList_580116 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsClustersNodePoolsList_580118(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersNodePoolsList_580117(
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
  var valid_580119 = path.getOrDefault("parent")
  valid_580119 = validateParameter(valid_580119, JString, required = true,
                                 default = nil)
  if valid_580119 != nil:
    section.add "parent", valid_580119
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: JString
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   zone: JString
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  section = newJObject()
  var valid_580120 = query.getOrDefault("key")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "key", valid_580120
  var valid_580121 = query.getOrDefault("pp")
  valid_580121 = validateParameter(valid_580121, JBool, required = false,
                                 default = newJBool(true))
  if valid_580121 != nil:
    section.add "pp", valid_580121
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
  var valid_580125 = query.getOrDefault("bearer_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "bearer_token", valid_580125
  var valid_580126 = query.getOrDefault("alt")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("json"))
  if valid_580126 != nil:
    section.add "alt", valid_580126
  var valid_580127 = query.getOrDefault("uploadType")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "uploadType", valid_580127
  var valid_580128 = query.getOrDefault("quotaUser")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "quotaUser", valid_580128
  var valid_580129 = query.getOrDefault("clusterId")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "clusterId", valid_580129
  var valid_580130 = query.getOrDefault("zone")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "zone", valid_580130
  var valid_580131 = query.getOrDefault("callback")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "callback", valid_580131
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
  var valid_580133 = query.getOrDefault("access_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "access_token", valid_580133
  var valid_580134 = query.getOrDefault("upload_protocol")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "upload_protocol", valid_580134
  var valid_580135 = query.getOrDefault("projectId")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "projectId", valid_580135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580136: Call_ContainerProjectsLocationsClustersNodePoolsList_580116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_ContainerProjectsLocationsClustersNodePoolsList_580116;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          clusterId: string = ""; zone: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          projectId: string = ""): Recallable =
  ## containerProjectsLocationsClustersNodePoolsList
  ## Lists the node pools for a cluster.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   clusterId: string
  ##            : The name of the cluster.
  ## This field is deprecated, use parent instead.
  ##   zone: string
  ##       : The name of the Google Compute Engine
  ## [zone](/compute/docs/zones#available) in which the cluster
  ## resides.
  ## This field is deprecated, use parent instead.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent (project, location, cluster id) where the node pools will be listed.
  ## Specified in the format 'projects/*/locations/*/clusters/*'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : The Google Developers Console [project ID or project
  ## number](https://developers.google.com/console/help/new/#projectnumber).
  ## This field is deprecated, use parent instead.
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  add(query_580139, "key", newJString(key))
  add(query_580139, "pp", newJBool(pp))
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "$.xgafv", newJString(Xgafv))
  add(query_580139, "bearer_token", newJString(bearerToken))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "uploadType", newJString(uploadType))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(query_580139, "clusterId", newJString(clusterId))
  add(query_580139, "zone", newJString(zone))
  add(query_580139, "callback", newJString(callback))
  add(path_580138, "parent", newJString(parent))
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "access_token", newJString(accessToken))
  add(query_580139, "upload_protocol", newJString(uploadProtocol))
  add(query_580139, "projectId", newJString(projectId))
  result = call_580137.call(path_580138, query_580139, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsList* = Call_ContainerProjectsLocationsClustersNodePoolsList_580116(
    name: "containerProjectsLocationsClustersNodePoolsList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1beta1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsList_580117,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsList_580118,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsList_580163 = ref object of OpenApiRestCall_578348
proc url_ContainerProjectsLocationsOperationsList_580165(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsOperationsList_580164(path: JsonNode;
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
  var valid_580166 = path.getOrDefault("parent")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "parent", valid_580166
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: JString
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: JString
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  section = newJObject()
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("pp")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "pp", valid_580168
  var valid_580169 = query.getOrDefault("prettyPrint")
  valid_580169 = validateParameter(valid_580169, JBool, required = false,
                                 default = newJBool(true))
  if valid_580169 != nil:
    section.add "prettyPrint", valid_580169
  var valid_580170 = query.getOrDefault("oauth_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "oauth_token", valid_580170
  var valid_580171 = query.getOrDefault("$.xgafv")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("1"))
  if valid_580171 != nil:
    section.add "$.xgafv", valid_580171
  var valid_580172 = query.getOrDefault("bearer_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "bearer_token", valid_580172
  var valid_580173 = query.getOrDefault("alt")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("json"))
  if valid_580173 != nil:
    section.add "alt", valid_580173
  var valid_580174 = query.getOrDefault("uploadType")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "uploadType", valid_580174
  var valid_580175 = query.getOrDefault("quotaUser")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "quotaUser", valid_580175
  var valid_580176 = query.getOrDefault("zone")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "zone", valid_580176
  var valid_580177 = query.getOrDefault("callback")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "callback", valid_580177
  var valid_580178 = query.getOrDefault("fields")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "fields", valid_580178
  var valid_580179 = query.getOrDefault("access_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "access_token", valid_580179
  var valid_580180 = query.getOrDefault("upload_protocol")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "upload_protocol", valid_580180
  var valid_580181 = query.getOrDefault("projectId")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "projectId", valid_580181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580182: Call_ContainerProjectsLocationsOperationsList_580163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_580182.validator(path, query, header, formData, body)
  let scheme = call_580182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580182.url(scheme.get, call_580182.host, call_580182.base,
                         call_580182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580182, url, valid)

proc call*(call_580183: Call_ContainerProjectsLocationsOperationsList_580163;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          zone: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; projectId: string = ""): Recallable =
  ## containerProjectsLocationsOperationsList
  ## Lists all operations in a project in a specific zone or all zones.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   zone: string
  ##       : The name of the Google Compute Engine [zone](/compute/docs/zones#available)
  ## to return operations for, or `-` for all zones.
  ## This field is deprecated, use parent instead.
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
  ##            : The Google Developers Console [project ID or project
  ## number](https://support.google.com/cloud/answer/6158840).
  ## This field is deprecated, use parent instead.
  var path_580184 = newJObject()
  var query_580185 = newJObject()
  add(query_580185, "key", newJString(key))
  add(query_580185, "pp", newJBool(pp))
  add(query_580185, "prettyPrint", newJBool(prettyPrint))
  add(query_580185, "oauth_token", newJString(oauthToken))
  add(query_580185, "$.xgafv", newJString(Xgafv))
  add(query_580185, "bearer_token", newJString(bearerToken))
  add(query_580185, "alt", newJString(alt))
  add(query_580185, "uploadType", newJString(uploadType))
  add(query_580185, "quotaUser", newJString(quotaUser))
  add(query_580185, "zone", newJString(zone))
  add(query_580185, "callback", newJString(callback))
  add(path_580184, "parent", newJString(parent))
  add(query_580185, "fields", newJString(fields))
  add(query_580185, "access_token", newJString(accessToken))
  add(query_580185, "upload_protocol", newJString(uploadProtocol))
  add(query_580185, "projectId", newJString(projectId))
  result = call_580183.call(path_580184, query_580185, nil, nil, nil)

var containerProjectsLocationsOperationsList* = Call_ContainerProjectsLocationsOperationsList_580163(
    name: "containerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1beta1/{parent}/operations",
    validator: validate_ContainerProjectsLocationsOperationsList_580164,
    base: "/", url: url_ContainerProjectsLocationsOperationsList_580165,
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
