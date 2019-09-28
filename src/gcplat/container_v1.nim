
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "container"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContainerProjectsZonesClustersCreate_579980 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersCreate_579982(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersCreate_579981(path: JsonNode;
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
  var valid_579983 = path.getOrDefault("zone")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "zone", valid_579983
  var valid_579984 = path.getOrDefault("projectId")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "projectId", valid_579984
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
  var valid_579985 = query.getOrDefault("upload_protocol")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "upload_protocol", valid_579985
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
  var valid_579990 = query.getOrDefault("callback")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "callback", valid_579990
  var valid_579991 = query.getOrDefault("access_token")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "access_token", valid_579991
  var valid_579992 = query.getOrDefault("uploadType")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "uploadType", valid_579992
  var valid_579993 = query.getOrDefault("key")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "key", valid_579993
  var valid_579994 = query.getOrDefault("$.xgafv")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("1"))
  if valid_579994 != nil:
    section.add "$.xgafv", valid_579994
  var valid_579995 = query.getOrDefault("prettyPrint")
  valid_579995 = validateParameter(valid_579995, JBool, required = false,
                                 default = newJBool(true))
  if valid_579995 != nil:
    section.add "prettyPrint", valid_579995
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

proc call*(call_579997: Call_ContainerProjectsZonesClustersCreate_579980;
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
  let valid = call_579997.validator(path, query, header, formData, body)
  let scheme = call_579997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579997.url(scheme.get, call_579997.host, call_579997.base,
                         call_579997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579997, url, valid)

proc call*(call_579998: Call_ContainerProjectsZonesClustersCreate_579980;
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
  var path_579999 = newJObject()
  var query_580000 = newJObject()
  var body_580001 = newJObject()
  add(query_580000, "upload_protocol", newJString(uploadProtocol))
  add(path_579999, "zone", newJString(zone))
  add(query_580000, "fields", newJString(fields))
  add(query_580000, "quotaUser", newJString(quotaUser))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "callback", newJString(callback))
  add(query_580000, "access_token", newJString(accessToken))
  add(query_580000, "uploadType", newJString(uploadType))
  add(query_580000, "key", newJString(key))
  add(path_579999, "projectId", newJString(projectId))
  add(query_580000, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580001 = body
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  result = call_579998.call(path_579999, query_580000, nil, nil, body_580001)

var containerProjectsZonesClustersCreate* = Call_ContainerProjectsZonesClustersCreate_579980(
    name: "containerProjectsZonesClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersCreate_579981, base: "/",
    url: url_ContainerProjectsZonesClustersCreate_579982, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersList_579690 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersList_579692(protocol: Scheme; host: string;
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

proc validate_ContainerProjectsZonesClustersList_579691(path: JsonNode;
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
  var valid_579818 = path.getOrDefault("zone")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "zone", valid_579818
  var valid_579819 = path.getOrDefault("projectId")
  valid_579819 = validateParameter(valid_579819, JString, required = true,
                                 default = nil)
  if valid_579819 != nil:
    section.add "projectId", valid_579819
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
  var valid_579820 = query.getOrDefault("upload_protocol")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "upload_protocol", valid_579820
  var valid_579821 = query.getOrDefault("fields")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "fields", valid_579821
  var valid_579822 = query.getOrDefault("quotaUser")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "quotaUser", valid_579822
  var valid_579836 = query.getOrDefault("alt")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = newJString("json"))
  if valid_579836 != nil:
    section.add "alt", valid_579836
  var valid_579837 = query.getOrDefault("oauth_token")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "oauth_token", valid_579837
  var valid_579838 = query.getOrDefault("callback")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "callback", valid_579838
  var valid_579839 = query.getOrDefault("access_token")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "access_token", valid_579839
  var valid_579840 = query.getOrDefault("uploadType")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "uploadType", valid_579840
  var valid_579841 = query.getOrDefault("parent")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "parent", valid_579841
  var valid_579842 = query.getOrDefault("key")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "key", valid_579842
  var valid_579843 = query.getOrDefault("$.xgafv")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = newJString("1"))
  if valid_579843 != nil:
    section.add "$.xgafv", valid_579843
  var valid_579844 = query.getOrDefault("prettyPrint")
  valid_579844 = validateParameter(valid_579844, JBool, required = false,
                                 default = newJBool(true))
  if valid_579844 != nil:
    section.add "prettyPrint", valid_579844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579867: Call_ContainerProjectsZonesClustersList_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_579867.validator(path, query, header, formData, body)
  let scheme = call_579867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579867.url(scheme.get, call_579867.host, call_579867.base,
                         call_579867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579867, url, valid)

proc call*(call_579938: Call_ContainerProjectsZonesClustersList_579690;
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
  var path_579939 = newJObject()
  var query_579941 = newJObject()
  add(query_579941, "upload_protocol", newJString(uploadProtocol))
  add(path_579939, "zone", newJString(zone))
  add(query_579941, "fields", newJString(fields))
  add(query_579941, "quotaUser", newJString(quotaUser))
  add(query_579941, "alt", newJString(alt))
  add(query_579941, "oauth_token", newJString(oauthToken))
  add(query_579941, "callback", newJString(callback))
  add(query_579941, "access_token", newJString(accessToken))
  add(query_579941, "uploadType", newJString(uploadType))
  add(query_579941, "parent", newJString(parent))
  add(query_579941, "key", newJString(key))
  add(path_579939, "projectId", newJString(projectId))
  add(query_579941, "$.xgafv", newJString(Xgafv))
  add(query_579941, "prettyPrint", newJBool(prettyPrint))
  result = call_579938.call(path_579939, query_579941, nil, nil, nil)

var containerProjectsZonesClustersList* = Call_ContainerProjectsZonesClustersList_579690(
    name: "containerProjectsZonesClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters",
    validator: validate_ContainerProjectsZonesClustersList_579691, base: "/",
    url: url_ContainerProjectsZonesClustersList_579692, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersUpdate_580024 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersUpdate_580026(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersUpdate_580025(path: JsonNode;
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
  var valid_580027 = path.getOrDefault("zone")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "zone", valid_580027
  var valid_580028 = path.getOrDefault("projectId")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "projectId", valid_580028
  var valid_580029 = path.getOrDefault("clusterId")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "clusterId", valid_580029
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
  var valid_580030 = query.getOrDefault("upload_protocol")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "upload_protocol", valid_580030
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("quotaUser")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "quotaUser", valid_580032
  var valid_580033 = query.getOrDefault("alt")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("json"))
  if valid_580033 != nil:
    section.add "alt", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("callback")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "callback", valid_580035
  var valid_580036 = query.getOrDefault("access_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "access_token", valid_580036
  var valid_580037 = query.getOrDefault("uploadType")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "uploadType", valid_580037
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("$.xgafv")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("1"))
  if valid_580039 != nil:
    section.add "$.xgafv", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
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

proc call*(call_580042: Call_ContainerProjectsZonesClustersUpdate_580024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the settings of a specific cluster.
  ## 
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_ContainerProjectsZonesClustersUpdate_580024;
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
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  var body_580046 = newJObject()
  add(query_580045, "upload_protocol", newJString(uploadProtocol))
  add(path_580044, "zone", newJString(zone))
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "callback", newJString(callback))
  add(query_580045, "access_token", newJString(accessToken))
  add(query_580045, "uploadType", newJString(uploadType))
  add(query_580045, "key", newJString(key))
  add(path_580044, "projectId", newJString(projectId))
  add(query_580045, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580046 = body
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  add(path_580044, "clusterId", newJString(clusterId))
  result = call_580043.call(path_580044, query_580045, nil, nil, body_580046)

var containerProjectsZonesClustersUpdate* = Call_ContainerProjectsZonesClustersUpdate_580024(
    name: "containerProjectsZonesClustersUpdate", meth: HttpMethod.HttpPut,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersUpdate_580025, base: "/",
    url: url_ContainerProjectsZonesClustersUpdate_580026, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersGet_580002 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersGet_580004(protocol: Scheme; host: string;
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

proc validate_ContainerProjectsZonesClustersGet_580003(path: JsonNode;
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
  var valid_580005 = path.getOrDefault("zone")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "zone", valid_580005
  var valid_580006 = path.getOrDefault("projectId")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = nil)
  if valid_580006 != nil:
    section.add "projectId", valid_580006
  var valid_580007 = path.getOrDefault("clusterId")
  valid_580007 = validateParameter(valid_580007, JString, required = true,
                                 default = nil)
  if valid_580007 != nil:
    section.add "clusterId", valid_580007
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
  var valid_580008 = query.getOrDefault("upload_protocol")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "upload_protocol", valid_580008
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("oauth_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "oauth_token", valid_580012
  var valid_580013 = query.getOrDefault("callback")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "callback", valid_580013
  var valid_580014 = query.getOrDefault("access_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "access_token", valid_580014
  var valid_580015 = query.getOrDefault("uploadType")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "uploadType", valid_580015
  var valid_580016 = query.getOrDefault("key")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "key", valid_580016
  var valid_580017 = query.getOrDefault("name")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "name", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_ContainerProjectsZonesClustersGet_580002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific cluster.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_ContainerProjectsZonesClustersGet_580002;
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
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  add(query_580023, "upload_protocol", newJString(uploadProtocol))
  add(path_580022, "zone", newJString(zone))
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "callback", newJString(callback))
  add(query_580023, "access_token", newJString(accessToken))
  add(query_580023, "uploadType", newJString(uploadType))
  add(query_580023, "key", newJString(key))
  add(query_580023, "name", newJString(name))
  add(path_580022, "projectId", newJString(projectId))
  add(query_580023, "$.xgafv", newJString(Xgafv))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  add(path_580022, "clusterId", newJString(clusterId))
  result = call_580021.call(path_580022, query_580023, nil, nil, nil)

var containerProjectsZonesClustersGet* = Call_ContainerProjectsZonesClustersGet_580002(
    name: "containerProjectsZonesClustersGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersGet_580003, base: "/",
    url: url_ContainerProjectsZonesClustersGet_580004, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersDelete_580047 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersDelete_580049(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersDelete_580048(path: JsonNode;
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
  var valid_580050 = path.getOrDefault("zone")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "zone", valid_580050
  var valid_580051 = path.getOrDefault("projectId")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "projectId", valid_580051
  var valid_580052 = path.getOrDefault("clusterId")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "clusterId", valid_580052
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
  var valid_580053 = query.getOrDefault("upload_protocol")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "upload_protocol", valid_580053
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("callback")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "callback", valid_580058
  var valid_580059 = query.getOrDefault("access_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "access_token", valid_580059
  var valid_580060 = query.getOrDefault("uploadType")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "uploadType", valid_580060
  var valid_580061 = query.getOrDefault("key")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "key", valid_580061
  var valid_580062 = query.getOrDefault("name")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "name", valid_580062
  var valid_580063 = query.getOrDefault("$.xgafv")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("1"))
  if valid_580063 != nil:
    section.add "$.xgafv", valid_580063
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

proc call*(call_580065: Call_ContainerProjectsZonesClustersDelete_580047;
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
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_ContainerProjectsZonesClustersDelete_580047;
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
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  add(query_580068, "upload_protocol", newJString(uploadProtocol))
  add(path_580067, "zone", newJString(zone))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "callback", newJString(callback))
  add(query_580068, "access_token", newJString(accessToken))
  add(query_580068, "uploadType", newJString(uploadType))
  add(query_580068, "key", newJString(key))
  add(query_580068, "name", newJString(name))
  add(path_580067, "projectId", newJString(projectId))
  add(query_580068, "$.xgafv", newJString(Xgafv))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  add(path_580067, "clusterId", newJString(clusterId))
  result = call_580066.call(path_580067, query_580068, nil, nil, nil)

var containerProjectsZonesClustersDelete* = Call_ContainerProjectsZonesClustersDelete_580047(
    name: "containerProjectsZonesClustersDelete", meth: HttpMethod.HttpDelete,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}",
    validator: validate_ContainerProjectsZonesClustersDelete_580048, base: "/",
    url: url_ContainerProjectsZonesClustersDelete_580049, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersAddons_580069 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersAddons_580071(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersAddons_580070(path: JsonNode;
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
  var valid_580072 = path.getOrDefault("zone")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "zone", valid_580072
  var valid_580073 = path.getOrDefault("projectId")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "projectId", valid_580073
  var valid_580074 = path.getOrDefault("clusterId")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "clusterId", valid_580074
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
  var valid_580075 = query.getOrDefault("upload_protocol")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "upload_protocol", valid_580075
  var valid_580076 = query.getOrDefault("fields")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "fields", valid_580076
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
  var valid_580080 = query.getOrDefault("callback")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "callback", valid_580080
  var valid_580081 = query.getOrDefault("access_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "access_token", valid_580081
  var valid_580082 = query.getOrDefault("uploadType")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "uploadType", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("$.xgafv")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("1"))
  if valid_580084 != nil:
    section.add "$.xgafv", valid_580084
  var valid_580085 = query.getOrDefault("prettyPrint")
  valid_580085 = validateParameter(valid_580085, JBool, required = false,
                                 default = newJBool(true))
  if valid_580085 != nil:
    section.add "prettyPrint", valid_580085
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

proc call*(call_580087: Call_ContainerProjectsZonesClustersAddons_580069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_ContainerProjectsZonesClustersAddons_580069;
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
  var path_580089 = newJObject()
  var query_580090 = newJObject()
  var body_580091 = newJObject()
  add(query_580090, "upload_protocol", newJString(uploadProtocol))
  add(path_580089, "zone", newJString(zone))
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "quotaUser", newJString(quotaUser))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(query_580090, "callback", newJString(callback))
  add(query_580090, "access_token", newJString(accessToken))
  add(query_580090, "uploadType", newJString(uploadType))
  add(query_580090, "key", newJString(key))
  add(path_580089, "projectId", newJString(projectId))
  add(query_580090, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580091 = body
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  add(path_580089, "clusterId", newJString(clusterId))
  result = call_580088.call(path_580089, query_580090, nil, nil, body_580091)

var containerProjectsZonesClustersAddons* = Call_ContainerProjectsZonesClustersAddons_580069(
    name: "containerProjectsZonesClustersAddons", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/addons",
    validator: validate_ContainerProjectsZonesClustersAddons_580070, base: "/",
    url: url_ContainerProjectsZonesClustersAddons_580071, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLegacyAbac_580092 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersLegacyAbac_580094(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersLegacyAbac_580093(path: JsonNode;
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
  var valid_580095 = path.getOrDefault("zone")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "zone", valid_580095
  var valid_580096 = path.getOrDefault("projectId")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "projectId", valid_580096
  var valid_580097 = path.getOrDefault("clusterId")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "clusterId", valid_580097
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
  var valid_580098 = query.getOrDefault("upload_protocol")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "upload_protocol", valid_580098
  var valid_580099 = query.getOrDefault("fields")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "fields", valid_580099
  var valid_580100 = query.getOrDefault("quotaUser")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "quotaUser", valid_580100
  var valid_580101 = query.getOrDefault("alt")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("json"))
  if valid_580101 != nil:
    section.add "alt", valid_580101
  var valid_580102 = query.getOrDefault("oauth_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "oauth_token", valid_580102
  var valid_580103 = query.getOrDefault("callback")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "callback", valid_580103
  var valid_580104 = query.getOrDefault("access_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "access_token", valid_580104
  var valid_580105 = query.getOrDefault("uploadType")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "uploadType", valid_580105
  var valid_580106 = query.getOrDefault("key")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "key", valid_580106
  var valid_580107 = query.getOrDefault("$.xgafv")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("1"))
  if valid_580107 != nil:
    section.add "$.xgafv", valid_580107
  var valid_580108 = query.getOrDefault("prettyPrint")
  valid_580108 = validateParameter(valid_580108, JBool, required = false,
                                 default = newJBool(true))
  if valid_580108 != nil:
    section.add "prettyPrint", valid_580108
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

proc call*(call_580110: Call_ContainerProjectsZonesClustersLegacyAbac_580092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_ContainerProjectsZonesClustersLegacyAbac_580092;
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
  var path_580112 = newJObject()
  var query_580113 = newJObject()
  var body_580114 = newJObject()
  add(query_580113, "upload_protocol", newJString(uploadProtocol))
  add(path_580112, "zone", newJString(zone))
  add(query_580113, "fields", newJString(fields))
  add(query_580113, "quotaUser", newJString(quotaUser))
  add(query_580113, "alt", newJString(alt))
  add(query_580113, "oauth_token", newJString(oauthToken))
  add(query_580113, "callback", newJString(callback))
  add(query_580113, "access_token", newJString(accessToken))
  add(query_580113, "uploadType", newJString(uploadType))
  add(query_580113, "key", newJString(key))
  add(path_580112, "projectId", newJString(projectId))
  add(query_580113, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580114 = body
  add(query_580113, "prettyPrint", newJBool(prettyPrint))
  add(path_580112, "clusterId", newJString(clusterId))
  result = call_580111.call(path_580112, query_580113, nil, nil, body_580114)

var containerProjectsZonesClustersLegacyAbac* = Call_ContainerProjectsZonesClustersLegacyAbac_580092(
    name: "containerProjectsZonesClustersLegacyAbac", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/legacyAbac",
    validator: validate_ContainerProjectsZonesClustersLegacyAbac_580093,
    base: "/", url: url_ContainerProjectsZonesClustersLegacyAbac_580094,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLocations_580115 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersLocations_580117(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersLocations_580116(path: JsonNode;
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
  var valid_580118 = path.getOrDefault("zone")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "zone", valid_580118
  var valid_580119 = path.getOrDefault("projectId")
  valid_580119 = validateParameter(valid_580119, JString, required = true,
                                 default = nil)
  if valid_580119 != nil:
    section.add "projectId", valid_580119
  var valid_580120 = path.getOrDefault("clusterId")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "clusterId", valid_580120
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
  var valid_580121 = query.getOrDefault("upload_protocol")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "upload_protocol", valid_580121
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
  var valid_580123 = query.getOrDefault("quotaUser")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "quotaUser", valid_580123
  var valid_580124 = query.getOrDefault("alt")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("json"))
  if valid_580124 != nil:
    section.add "alt", valid_580124
  var valid_580125 = query.getOrDefault("oauth_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "oauth_token", valid_580125
  var valid_580126 = query.getOrDefault("callback")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "callback", valid_580126
  var valid_580127 = query.getOrDefault("access_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "access_token", valid_580127
  var valid_580128 = query.getOrDefault("uploadType")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "uploadType", valid_580128
  var valid_580129 = query.getOrDefault("key")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "key", valid_580129
  var valid_580130 = query.getOrDefault("$.xgafv")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("1"))
  if valid_580130 != nil:
    section.add "$.xgafv", valid_580130
  var valid_580131 = query.getOrDefault("prettyPrint")
  valid_580131 = validateParameter(valid_580131, JBool, required = false,
                                 default = newJBool(true))
  if valid_580131 != nil:
    section.add "prettyPrint", valid_580131
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

proc call*(call_580133: Call_ContainerProjectsZonesClustersLocations_580115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_ContainerProjectsZonesClustersLocations_580115;
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
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  var body_580137 = newJObject()
  add(query_580136, "upload_protocol", newJString(uploadProtocol))
  add(path_580135, "zone", newJString(zone))
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "quotaUser", newJString(quotaUser))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(query_580136, "callback", newJString(callback))
  add(query_580136, "access_token", newJString(accessToken))
  add(query_580136, "uploadType", newJString(uploadType))
  add(query_580136, "key", newJString(key))
  add(path_580135, "projectId", newJString(projectId))
  add(query_580136, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580137 = body
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  add(path_580135, "clusterId", newJString(clusterId))
  result = call_580134.call(path_580135, query_580136, nil, nil, body_580137)

var containerProjectsZonesClustersLocations* = Call_ContainerProjectsZonesClustersLocations_580115(
    name: "containerProjectsZonesClustersLocations", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/locations",
    validator: validate_ContainerProjectsZonesClustersLocations_580116, base: "/",
    url: url_ContainerProjectsZonesClustersLocations_580117,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersLogging_580138 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersLogging_580140(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersLogging_580139(path: JsonNode;
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
  var valid_580141 = path.getOrDefault("zone")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "zone", valid_580141
  var valid_580142 = path.getOrDefault("projectId")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "projectId", valid_580142
  var valid_580143 = path.getOrDefault("clusterId")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "clusterId", valid_580143
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
  var valid_580144 = query.getOrDefault("upload_protocol")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "upload_protocol", valid_580144
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("quotaUser")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "quotaUser", valid_580146
  var valid_580147 = query.getOrDefault("alt")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("json"))
  if valid_580147 != nil:
    section.add "alt", valid_580147
  var valid_580148 = query.getOrDefault("oauth_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "oauth_token", valid_580148
  var valid_580149 = query.getOrDefault("callback")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "callback", valid_580149
  var valid_580150 = query.getOrDefault("access_token")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "access_token", valid_580150
  var valid_580151 = query.getOrDefault("uploadType")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "uploadType", valid_580151
  var valid_580152 = query.getOrDefault("key")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "key", valid_580152
  var valid_580153 = query.getOrDefault("$.xgafv")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("1"))
  if valid_580153 != nil:
    section.add "$.xgafv", valid_580153
  var valid_580154 = query.getOrDefault("prettyPrint")
  valid_580154 = validateParameter(valid_580154, JBool, required = false,
                                 default = newJBool(true))
  if valid_580154 != nil:
    section.add "prettyPrint", valid_580154
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

proc call*(call_580156: Call_ContainerProjectsZonesClustersLogging_580138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_580156.validator(path, query, header, formData, body)
  let scheme = call_580156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580156.url(scheme.get, call_580156.host, call_580156.base,
                         call_580156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580156, url, valid)

proc call*(call_580157: Call_ContainerProjectsZonesClustersLogging_580138;
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
  var path_580158 = newJObject()
  var query_580159 = newJObject()
  var body_580160 = newJObject()
  add(query_580159, "upload_protocol", newJString(uploadProtocol))
  add(path_580158, "zone", newJString(zone))
  add(query_580159, "fields", newJString(fields))
  add(query_580159, "quotaUser", newJString(quotaUser))
  add(query_580159, "alt", newJString(alt))
  add(query_580159, "oauth_token", newJString(oauthToken))
  add(query_580159, "callback", newJString(callback))
  add(query_580159, "access_token", newJString(accessToken))
  add(query_580159, "uploadType", newJString(uploadType))
  add(query_580159, "key", newJString(key))
  add(path_580158, "projectId", newJString(projectId))
  add(query_580159, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580160 = body
  add(query_580159, "prettyPrint", newJBool(prettyPrint))
  add(path_580158, "clusterId", newJString(clusterId))
  result = call_580157.call(path_580158, query_580159, nil, nil, body_580160)

var containerProjectsZonesClustersLogging* = Call_ContainerProjectsZonesClustersLogging_580138(
    name: "containerProjectsZonesClustersLogging", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/logging",
    validator: validate_ContainerProjectsZonesClustersLogging_580139, base: "/",
    url: url_ContainerProjectsZonesClustersLogging_580140, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMaster_580161 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersMaster_580163(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersMaster_580162(path: JsonNode;
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
  var valid_580164 = path.getOrDefault("zone")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "zone", valid_580164
  var valid_580165 = path.getOrDefault("projectId")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "projectId", valid_580165
  var valid_580166 = path.getOrDefault("clusterId")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "clusterId", valid_580166
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
  var valid_580167 = query.getOrDefault("upload_protocol")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "upload_protocol", valid_580167
  var valid_580168 = query.getOrDefault("fields")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "fields", valid_580168
  var valid_580169 = query.getOrDefault("quotaUser")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "quotaUser", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("oauth_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "oauth_token", valid_580171
  var valid_580172 = query.getOrDefault("callback")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "callback", valid_580172
  var valid_580173 = query.getOrDefault("access_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "access_token", valid_580173
  var valid_580174 = query.getOrDefault("uploadType")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "uploadType", valid_580174
  var valid_580175 = query.getOrDefault("key")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "key", valid_580175
  var valid_580176 = query.getOrDefault("$.xgafv")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("1"))
  if valid_580176 != nil:
    section.add "$.xgafv", valid_580176
  var valid_580177 = query.getOrDefault("prettyPrint")
  valid_580177 = validateParameter(valid_580177, JBool, required = false,
                                 default = newJBool(true))
  if valid_580177 != nil:
    section.add "prettyPrint", valid_580177
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

proc call*(call_580179: Call_ContainerProjectsZonesClustersMaster_580161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_ContainerProjectsZonesClustersMaster_580161;
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  var body_580183 = newJObject()
  add(query_580182, "upload_protocol", newJString(uploadProtocol))
  add(path_580181, "zone", newJString(zone))
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "callback", newJString(callback))
  add(query_580182, "access_token", newJString(accessToken))
  add(query_580182, "uploadType", newJString(uploadType))
  add(query_580182, "key", newJString(key))
  add(path_580181, "projectId", newJString(projectId))
  add(query_580182, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580183 = body
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  add(path_580181, "clusterId", newJString(clusterId))
  result = call_580180.call(path_580181, query_580182, nil, nil, body_580183)

var containerProjectsZonesClustersMaster* = Call_ContainerProjectsZonesClustersMaster_580161(
    name: "containerProjectsZonesClustersMaster", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/master",
    validator: validate_ContainerProjectsZonesClustersMaster_580162, base: "/",
    url: url_ContainerProjectsZonesClustersMaster_580163, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersMonitoring_580184 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersMonitoring_580186(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersMonitoring_580185(path: JsonNode;
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
  var valid_580187 = path.getOrDefault("zone")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "zone", valid_580187
  var valid_580188 = path.getOrDefault("projectId")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "projectId", valid_580188
  var valid_580189 = path.getOrDefault("clusterId")
  valid_580189 = validateParameter(valid_580189, JString, required = true,
                                 default = nil)
  if valid_580189 != nil:
    section.add "clusterId", valid_580189
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
  var valid_580190 = query.getOrDefault("upload_protocol")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "upload_protocol", valid_580190
  var valid_580191 = query.getOrDefault("fields")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "fields", valid_580191
  var valid_580192 = query.getOrDefault("quotaUser")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "quotaUser", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("callback")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "callback", valid_580195
  var valid_580196 = query.getOrDefault("access_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "access_token", valid_580196
  var valid_580197 = query.getOrDefault("uploadType")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "uploadType", valid_580197
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("$.xgafv")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("1"))
  if valid_580199 != nil:
    section.add "$.xgafv", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
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

proc call*(call_580202: Call_ContainerProjectsZonesClustersMonitoring_580184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_580202.validator(path, query, header, formData, body)
  let scheme = call_580202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580202.url(scheme.get, call_580202.host, call_580202.base,
                         call_580202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580202, url, valid)

proc call*(call_580203: Call_ContainerProjectsZonesClustersMonitoring_580184;
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
  var path_580204 = newJObject()
  var query_580205 = newJObject()
  var body_580206 = newJObject()
  add(query_580205, "upload_protocol", newJString(uploadProtocol))
  add(path_580204, "zone", newJString(zone))
  add(query_580205, "fields", newJString(fields))
  add(query_580205, "quotaUser", newJString(quotaUser))
  add(query_580205, "alt", newJString(alt))
  add(query_580205, "oauth_token", newJString(oauthToken))
  add(query_580205, "callback", newJString(callback))
  add(query_580205, "access_token", newJString(accessToken))
  add(query_580205, "uploadType", newJString(uploadType))
  add(query_580205, "key", newJString(key))
  add(path_580204, "projectId", newJString(projectId))
  add(query_580205, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580206 = body
  add(query_580205, "prettyPrint", newJBool(prettyPrint))
  add(path_580204, "clusterId", newJString(clusterId))
  result = call_580203.call(path_580204, query_580205, nil, nil, body_580206)

var containerProjectsZonesClustersMonitoring* = Call_ContainerProjectsZonesClustersMonitoring_580184(
    name: "containerProjectsZonesClustersMonitoring", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/monitoring",
    validator: validate_ContainerProjectsZonesClustersMonitoring_580185,
    base: "/", url: url_ContainerProjectsZonesClustersMonitoring_580186,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsCreate_580229 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsCreate_580231(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsCreate_580230(
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
  var valid_580232 = path.getOrDefault("zone")
  valid_580232 = validateParameter(valid_580232, JString, required = true,
                                 default = nil)
  if valid_580232 != nil:
    section.add "zone", valid_580232
  var valid_580233 = path.getOrDefault("projectId")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "projectId", valid_580233
  var valid_580234 = path.getOrDefault("clusterId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "clusterId", valid_580234
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
  var valid_580235 = query.getOrDefault("upload_protocol")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "upload_protocol", valid_580235
  var valid_580236 = query.getOrDefault("fields")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "fields", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("oauth_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "oauth_token", valid_580239
  var valid_580240 = query.getOrDefault("callback")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "callback", valid_580240
  var valid_580241 = query.getOrDefault("access_token")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "access_token", valid_580241
  var valid_580242 = query.getOrDefault("uploadType")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "uploadType", valid_580242
  var valid_580243 = query.getOrDefault("key")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "key", valid_580243
  var valid_580244 = query.getOrDefault("$.xgafv")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("1"))
  if valid_580244 != nil:
    section.add "$.xgafv", valid_580244
  var valid_580245 = query.getOrDefault("prettyPrint")
  valid_580245 = validateParameter(valid_580245, JBool, required = false,
                                 default = newJBool(true))
  if valid_580245 != nil:
    section.add "prettyPrint", valid_580245
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

proc call*(call_580247: Call_ContainerProjectsZonesClustersNodePoolsCreate_580229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_580247.validator(path, query, header, formData, body)
  let scheme = call_580247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580247.url(scheme.get, call_580247.host, call_580247.base,
                         call_580247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580247, url, valid)

proc call*(call_580248: Call_ContainerProjectsZonesClustersNodePoolsCreate_580229;
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
  var path_580249 = newJObject()
  var query_580250 = newJObject()
  var body_580251 = newJObject()
  add(query_580250, "upload_protocol", newJString(uploadProtocol))
  add(path_580249, "zone", newJString(zone))
  add(query_580250, "fields", newJString(fields))
  add(query_580250, "quotaUser", newJString(quotaUser))
  add(query_580250, "alt", newJString(alt))
  add(query_580250, "oauth_token", newJString(oauthToken))
  add(query_580250, "callback", newJString(callback))
  add(query_580250, "access_token", newJString(accessToken))
  add(query_580250, "uploadType", newJString(uploadType))
  add(query_580250, "key", newJString(key))
  add(path_580249, "projectId", newJString(projectId))
  add(query_580250, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580251 = body
  add(query_580250, "prettyPrint", newJBool(prettyPrint))
  add(path_580249, "clusterId", newJString(clusterId))
  result = call_580248.call(path_580249, query_580250, nil, nil, body_580251)

var containerProjectsZonesClustersNodePoolsCreate* = Call_ContainerProjectsZonesClustersNodePoolsCreate_580229(
    name: "containerProjectsZonesClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsCreate_580230,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsCreate_580231,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsList_580207 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsList_580209(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsList_580208(path: JsonNode;
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
  var valid_580210 = path.getOrDefault("zone")
  valid_580210 = validateParameter(valid_580210, JString, required = true,
                                 default = nil)
  if valid_580210 != nil:
    section.add "zone", valid_580210
  var valid_580211 = path.getOrDefault("projectId")
  valid_580211 = validateParameter(valid_580211, JString, required = true,
                                 default = nil)
  if valid_580211 != nil:
    section.add "projectId", valid_580211
  var valid_580212 = path.getOrDefault("clusterId")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "clusterId", valid_580212
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
  var valid_580213 = query.getOrDefault("upload_protocol")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "upload_protocol", valid_580213
  var valid_580214 = query.getOrDefault("fields")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "fields", valid_580214
  var valid_580215 = query.getOrDefault("quotaUser")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "quotaUser", valid_580215
  var valid_580216 = query.getOrDefault("alt")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = newJString("json"))
  if valid_580216 != nil:
    section.add "alt", valid_580216
  var valid_580217 = query.getOrDefault("oauth_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "oauth_token", valid_580217
  var valid_580218 = query.getOrDefault("callback")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "callback", valid_580218
  var valid_580219 = query.getOrDefault("access_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "access_token", valid_580219
  var valid_580220 = query.getOrDefault("uploadType")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "uploadType", valid_580220
  var valid_580221 = query.getOrDefault("parent")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "parent", valid_580221
  var valid_580222 = query.getOrDefault("key")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "key", valid_580222
  var valid_580223 = query.getOrDefault("$.xgafv")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("1"))
  if valid_580223 != nil:
    section.add "$.xgafv", valid_580223
  var valid_580224 = query.getOrDefault("prettyPrint")
  valid_580224 = validateParameter(valid_580224, JBool, required = false,
                                 default = newJBool(true))
  if valid_580224 != nil:
    section.add "prettyPrint", valid_580224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580225: Call_ContainerProjectsZonesClustersNodePoolsList_580207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_580225.validator(path, query, header, formData, body)
  let scheme = call_580225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580225.url(scheme.get, call_580225.host, call_580225.base,
                         call_580225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580225, url, valid)

proc call*(call_580226: Call_ContainerProjectsZonesClustersNodePoolsList_580207;
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
  var path_580227 = newJObject()
  var query_580228 = newJObject()
  add(query_580228, "upload_protocol", newJString(uploadProtocol))
  add(path_580227, "zone", newJString(zone))
  add(query_580228, "fields", newJString(fields))
  add(query_580228, "quotaUser", newJString(quotaUser))
  add(query_580228, "alt", newJString(alt))
  add(query_580228, "oauth_token", newJString(oauthToken))
  add(query_580228, "callback", newJString(callback))
  add(query_580228, "access_token", newJString(accessToken))
  add(query_580228, "uploadType", newJString(uploadType))
  add(query_580228, "parent", newJString(parent))
  add(query_580228, "key", newJString(key))
  add(path_580227, "projectId", newJString(projectId))
  add(query_580228, "$.xgafv", newJString(Xgafv))
  add(query_580228, "prettyPrint", newJBool(prettyPrint))
  add(path_580227, "clusterId", newJString(clusterId))
  result = call_580226.call(path_580227, query_580228, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsList* = Call_ContainerProjectsZonesClustersNodePoolsList_580207(
    name: "containerProjectsZonesClustersNodePoolsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools",
    validator: validate_ContainerProjectsZonesClustersNodePoolsList_580208,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsList_580209,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsGet_580252 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsGet_580254(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsGet_580253(path: JsonNode;
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
  var valid_580255 = path.getOrDefault("zone")
  valid_580255 = validateParameter(valid_580255, JString, required = true,
                                 default = nil)
  if valid_580255 != nil:
    section.add "zone", valid_580255
  var valid_580256 = path.getOrDefault("nodePoolId")
  valid_580256 = validateParameter(valid_580256, JString, required = true,
                                 default = nil)
  if valid_580256 != nil:
    section.add "nodePoolId", valid_580256
  var valid_580257 = path.getOrDefault("projectId")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "projectId", valid_580257
  var valid_580258 = path.getOrDefault("clusterId")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "clusterId", valid_580258
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
  var valid_580259 = query.getOrDefault("upload_protocol")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "upload_protocol", valid_580259
  var valid_580260 = query.getOrDefault("fields")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "fields", valid_580260
  var valid_580261 = query.getOrDefault("quotaUser")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "quotaUser", valid_580261
  var valid_580262 = query.getOrDefault("alt")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = newJString("json"))
  if valid_580262 != nil:
    section.add "alt", valid_580262
  var valid_580263 = query.getOrDefault("oauth_token")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "oauth_token", valid_580263
  var valid_580264 = query.getOrDefault("callback")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "callback", valid_580264
  var valid_580265 = query.getOrDefault("access_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "access_token", valid_580265
  var valid_580266 = query.getOrDefault("uploadType")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "uploadType", valid_580266
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("name")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "name", valid_580268
  var valid_580269 = query.getOrDefault("$.xgafv")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("1"))
  if valid_580269 != nil:
    section.add "$.xgafv", valid_580269
  var valid_580270 = query.getOrDefault("prettyPrint")
  valid_580270 = validateParameter(valid_580270, JBool, required = false,
                                 default = newJBool(true))
  if valid_580270 != nil:
    section.add "prettyPrint", valid_580270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580271: Call_ContainerProjectsZonesClustersNodePoolsGet_580252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_580271.validator(path, query, header, formData, body)
  let scheme = call_580271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580271.url(scheme.get, call_580271.host, call_580271.base,
                         call_580271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580271, url, valid)

proc call*(call_580272: Call_ContainerProjectsZonesClustersNodePoolsGet_580252;
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
  var path_580273 = newJObject()
  var query_580274 = newJObject()
  add(query_580274, "upload_protocol", newJString(uploadProtocol))
  add(path_580273, "zone", newJString(zone))
  add(query_580274, "fields", newJString(fields))
  add(query_580274, "quotaUser", newJString(quotaUser))
  add(query_580274, "alt", newJString(alt))
  add(query_580274, "oauth_token", newJString(oauthToken))
  add(query_580274, "callback", newJString(callback))
  add(query_580274, "access_token", newJString(accessToken))
  add(query_580274, "uploadType", newJString(uploadType))
  add(path_580273, "nodePoolId", newJString(nodePoolId))
  add(query_580274, "key", newJString(key))
  add(query_580274, "name", newJString(name))
  add(path_580273, "projectId", newJString(projectId))
  add(query_580274, "$.xgafv", newJString(Xgafv))
  add(query_580274, "prettyPrint", newJBool(prettyPrint))
  add(path_580273, "clusterId", newJString(clusterId))
  result = call_580272.call(path_580273, query_580274, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsGet* = Call_ContainerProjectsZonesClustersNodePoolsGet_580252(
    name: "containerProjectsZonesClustersNodePoolsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsGet_580253,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsGet_580254,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsDelete_580275 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsDelete_580277(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsDelete_580276(
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
  var valid_580278 = path.getOrDefault("zone")
  valid_580278 = validateParameter(valid_580278, JString, required = true,
                                 default = nil)
  if valid_580278 != nil:
    section.add "zone", valid_580278
  var valid_580279 = path.getOrDefault("nodePoolId")
  valid_580279 = validateParameter(valid_580279, JString, required = true,
                                 default = nil)
  if valid_580279 != nil:
    section.add "nodePoolId", valid_580279
  var valid_580280 = path.getOrDefault("projectId")
  valid_580280 = validateParameter(valid_580280, JString, required = true,
                                 default = nil)
  if valid_580280 != nil:
    section.add "projectId", valid_580280
  var valid_580281 = path.getOrDefault("clusterId")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "clusterId", valid_580281
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
  var valid_580282 = query.getOrDefault("upload_protocol")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "upload_protocol", valid_580282
  var valid_580283 = query.getOrDefault("fields")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "fields", valid_580283
  var valid_580284 = query.getOrDefault("quotaUser")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "quotaUser", valid_580284
  var valid_580285 = query.getOrDefault("alt")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = newJString("json"))
  if valid_580285 != nil:
    section.add "alt", valid_580285
  var valid_580286 = query.getOrDefault("oauth_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "oauth_token", valid_580286
  var valid_580287 = query.getOrDefault("callback")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "callback", valid_580287
  var valid_580288 = query.getOrDefault("access_token")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "access_token", valid_580288
  var valid_580289 = query.getOrDefault("uploadType")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "uploadType", valid_580289
  var valid_580290 = query.getOrDefault("key")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "key", valid_580290
  var valid_580291 = query.getOrDefault("name")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "name", valid_580291
  var valid_580292 = query.getOrDefault("$.xgafv")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("1"))
  if valid_580292 != nil:
    section.add "$.xgafv", valid_580292
  var valid_580293 = query.getOrDefault("prettyPrint")
  valid_580293 = validateParameter(valid_580293, JBool, required = false,
                                 default = newJBool(true))
  if valid_580293 != nil:
    section.add "prettyPrint", valid_580293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580294: Call_ContainerProjectsZonesClustersNodePoolsDelete_580275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_580294.validator(path, query, header, formData, body)
  let scheme = call_580294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580294.url(scheme.get, call_580294.host, call_580294.base,
                         call_580294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580294, url, valid)

proc call*(call_580295: Call_ContainerProjectsZonesClustersNodePoolsDelete_580275;
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
  var path_580296 = newJObject()
  var query_580297 = newJObject()
  add(query_580297, "upload_protocol", newJString(uploadProtocol))
  add(path_580296, "zone", newJString(zone))
  add(query_580297, "fields", newJString(fields))
  add(query_580297, "quotaUser", newJString(quotaUser))
  add(query_580297, "alt", newJString(alt))
  add(query_580297, "oauth_token", newJString(oauthToken))
  add(query_580297, "callback", newJString(callback))
  add(query_580297, "access_token", newJString(accessToken))
  add(query_580297, "uploadType", newJString(uploadType))
  add(path_580296, "nodePoolId", newJString(nodePoolId))
  add(query_580297, "key", newJString(key))
  add(query_580297, "name", newJString(name))
  add(path_580296, "projectId", newJString(projectId))
  add(query_580297, "$.xgafv", newJString(Xgafv))
  add(query_580297, "prettyPrint", newJBool(prettyPrint))
  add(path_580296, "clusterId", newJString(clusterId))
  result = call_580295.call(path_580296, query_580297, nil, nil, nil)

var containerProjectsZonesClustersNodePoolsDelete* = Call_ContainerProjectsZonesClustersNodePoolsDelete_580275(
    name: "containerProjectsZonesClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}",
    validator: validate_ContainerProjectsZonesClustersNodePoolsDelete_580276,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsDelete_580277,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580298 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsAutoscaling_580300(
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

proc validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_580299(
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
  var valid_580301 = path.getOrDefault("zone")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "zone", valid_580301
  var valid_580302 = path.getOrDefault("nodePoolId")
  valid_580302 = validateParameter(valid_580302, JString, required = true,
                                 default = nil)
  if valid_580302 != nil:
    section.add "nodePoolId", valid_580302
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
  var valid_580305 = query.getOrDefault("upload_protocol")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "upload_protocol", valid_580305
  var valid_580306 = query.getOrDefault("fields")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "fields", valid_580306
  var valid_580307 = query.getOrDefault("quotaUser")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "quotaUser", valid_580307
  var valid_580308 = query.getOrDefault("alt")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = newJString("json"))
  if valid_580308 != nil:
    section.add "alt", valid_580308
  var valid_580309 = query.getOrDefault("oauth_token")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "oauth_token", valid_580309
  var valid_580310 = query.getOrDefault("callback")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "callback", valid_580310
  var valid_580311 = query.getOrDefault("access_token")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "access_token", valid_580311
  var valid_580312 = query.getOrDefault("uploadType")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "uploadType", valid_580312
  var valid_580313 = query.getOrDefault("key")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "key", valid_580313
  var valid_580314 = query.getOrDefault("$.xgafv")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = newJString("1"))
  if valid_580314 != nil:
    section.add "$.xgafv", valid_580314
  var valid_580315 = query.getOrDefault("prettyPrint")
  valid_580315 = validateParameter(valid_580315, JBool, required = false,
                                 default = newJBool(true))
  if valid_580315 != nil:
    section.add "prettyPrint", valid_580315
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

proc call*(call_580317: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_580317.validator(path, query, header, formData, body)
  let scheme = call_580317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580317.url(scheme.get, call_580317.host, call_580317.base,
                         call_580317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580317, url, valid)

proc call*(call_580318: Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580298;
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
  var path_580319 = newJObject()
  var query_580320 = newJObject()
  var body_580321 = newJObject()
  add(query_580320, "upload_protocol", newJString(uploadProtocol))
  add(path_580319, "zone", newJString(zone))
  add(query_580320, "fields", newJString(fields))
  add(query_580320, "quotaUser", newJString(quotaUser))
  add(query_580320, "alt", newJString(alt))
  add(query_580320, "oauth_token", newJString(oauthToken))
  add(query_580320, "callback", newJString(callback))
  add(query_580320, "access_token", newJString(accessToken))
  add(query_580320, "uploadType", newJString(uploadType))
  add(path_580319, "nodePoolId", newJString(nodePoolId))
  add(query_580320, "key", newJString(key))
  add(path_580319, "projectId", newJString(projectId))
  add(query_580320, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580321 = body
  add(query_580320, "prettyPrint", newJBool(prettyPrint))
  add(path_580319, "clusterId", newJString(clusterId))
  result = call_580318.call(path_580319, query_580320, nil, nil, body_580321)

var containerProjectsZonesClustersNodePoolsAutoscaling* = Call_ContainerProjectsZonesClustersNodePoolsAutoscaling_580298(
    name: "containerProjectsZonesClustersNodePoolsAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/autoscaling",
    validator: validate_ContainerProjectsZonesClustersNodePoolsAutoscaling_580299,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsAutoscaling_580300,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580322 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsSetManagement_580324(
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

proc validate_ContainerProjectsZonesClustersNodePoolsSetManagement_580323(
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
  var valid_580325 = path.getOrDefault("zone")
  valid_580325 = validateParameter(valid_580325, JString, required = true,
                                 default = nil)
  if valid_580325 != nil:
    section.add "zone", valid_580325
  var valid_580326 = path.getOrDefault("nodePoolId")
  valid_580326 = validateParameter(valid_580326, JString, required = true,
                                 default = nil)
  if valid_580326 != nil:
    section.add "nodePoolId", valid_580326
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
  var valid_580329 = query.getOrDefault("upload_protocol")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "upload_protocol", valid_580329
  var valid_580330 = query.getOrDefault("fields")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "fields", valid_580330
  var valid_580331 = query.getOrDefault("quotaUser")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "quotaUser", valid_580331
  var valid_580332 = query.getOrDefault("alt")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = newJString("json"))
  if valid_580332 != nil:
    section.add "alt", valid_580332
  var valid_580333 = query.getOrDefault("oauth_token")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "oauth_token", valid_580333
  var valid_580334 = query.getOrDefault("callback")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "callback", valid_580334
  var valid_580335 = query.getOrDefault("access_token")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "access_token", valid_580335
  var valid_580336 = query.getOrDefault("uploadType")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "uploadType", valid_580336
  var valid_580337 = query.getOrDefault("key")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "key", valid_580337
  var valid_580338 = query.getOrDefault("$.xgafv")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = newJString("1"))
  if valid_580338 != nil:
    section.add "$.xgafv", valid_580338
  var valid_580339 = query.getOrDefault("prettyPrint")
  valid_580339 = validateParameter(valid_580339, JBool, required = false,
                                 default = newJBool(true))
  if valid_580339 != nil:
    section.add "prettyPrint", valid_580339
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

proc call*(call_580341: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_580341.validator(path, query, header, formData, body)
  let scheme = call_580341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580341.url(scheme.get, call_580341.host, call_580341.base,
                         call_580341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580341, url, valid)

proc call*(call_580342: Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580322;
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
  var path_580343 = newJObject()
  var query_580344 = newJObject()
  var body_580345 = newJObject()
  add(query_580344, "upload_protocol", newJString(uploadProtocol))
  add(path_580343, "zone", newJString(zone))
  add(query_580344, "fields", newJString(fields))
  add(query_580344, "quotaUser", newJString(quotaUser))
  add(query_580344, "alt", newJString(alt))
  add(query_580344, "oauth_token", newJString(oauthToken))
  add(query_580344, "callback", newJString(callback))
  add(query_580344, "access_token", newJString(accessToken))
  add(query_580344, "uploadType", newJString(uploadType))
  add(path_580343, "nodePoolId", newJString(nodePoolId))
  add(query_580344, "key", newJString(key))
  add(path_580343, "projectId", newJString(projectId))
  add(query_580344, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580345 = body
  add(query_580344, "prettyPrint", newJBool(prettyPrint))
  add(path_580343, "clusterId", newJString(clusterId))
  result = call_580342.call(path_580343, query_580344, nil, nil, body_580345)

var containerProjectsZonesClustersNodePoolsSetManagement* = Call_ContainerProjectsZonesClustersNodePoolsSetManagement_580322(
    name: "containerProjectsZonesClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setManagement",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetManagement_580323,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetManagement_580324,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsSetSize_580346 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsSetSize_580348(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsSetSize_580347(
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
  var valid_580349 = path.getOrDefault("zone")
  valid_580349 = validateParameter(valid_580349, JString, required = true,
                                 default = nil)
  if valid_580349 != nil:
    section.add "zone", valid_580349
  var valid_580350 = path.getOrDefault("nodePoolId")
  valid_580350 = validateParameter(valid_580350, JString, required = true,
                                 default = nil)
  if valid_580350 != nil:
    section.add "nodePoolId", valid_580350
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
  var valid_580353 = query.getOrDefault("upload_protocol")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "upload_protocol", valid_580353
  var valid_580354 = query.getOrDefault("fields")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "fields", valid_580354
  var valid_580355 = query.getOrDefault("quotaUser")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "quotaUser", valid_580355
  var valid_580356 = query.getOrDefault("alt")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = newJString("json"))
  if valid_580356 != nil:
    section.add "alt", valid_580356
  var valid_580357 = query.getOrDefault("oauth_token")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "oauth_token", valid_580357
  var valid_580358 = query.getOrDefault("callback")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "callback", valid_580358
  var valid_580359 = query.getOrDefault("access_token")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "access_token", valid_580359
  var valid_580360 = query.getOrDefault("uploadType")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "uploadType", valid_580360
  var valid_580361 = query.getOrDefault("key")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "key", valid_580361
  var valid_580362 = query.getOrDefault("$.xgafv")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = newJString("1"))
  if valid_580362 != nil:
    section.add "$.xgafv", valid_580362
  var valid_580363 = query.getOrDefault("prettyPrint")
  valid_580363 = validateParameter(valid_580363, JBool, required = false,
                                 default = newJBool(true))
  if valid_580363 != nil:
    section.add "prettyPrint", valid_580363
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

proc call*(call_580365: Call_ContainerProjectsZonesClustersNodePoolsSetSize_580346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_580365.validator(path, query, header, formData, body)
  let scheme = call_580365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580365.url(scheme.get, call_580365.host, call_580365.base,
                         call_580365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580365, url, valid)

proc call*(call_580366: Call_ContainerProjectsZonesClustersNodePoolsSetSize_580346;
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
  var path_580367 = newJObject()
  var query_580368 = newJObject()
  var body_580369 = newJObject()
  add(query_580368, "upload_protocol", newJString(uploadProtocol))
  add(path_580367, "zone", newJString(zone))
  add(query_580368, "fields", newJString(fields))
  add(query_580368, "quotaUser", newJString(quotaUser))
  add(query_580368, "alt", newJString(alt))
  add(query_580368, "oauth_token", newJString(oauthToken))
  add(query_580368, "callback", newJString(callback))
  add(query_580368, "access_token", newJString(accessToken))
  add(query_580368, "uploadType", newJString(uploadType))
  add(path_580367, "nodePoolId", newJString(nodePoolId))
  add(query_580368, "key", newJString(key))
  add(path_580367, "projectId", newJString(projectId))
  add(query_580368, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580369 = body
  add(query_580368, "prettyPrint", newJBool(prettyPrint))
  add(path_580367, "clusterId", newJString(clusterId))
  result = call_580366.call(path_580367, query_580368, nil, nil, body_580369)

var containerProjectsZonesClustersNodePoolsSetSize* = Call_ContainerProjectsZonesClustersNodePoolsSetSize_580346(
    name: "containerProjectsZonesClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/setSize",
    validator: validate_ContainerProjectsZonesClustersNodePoolsSetSize_580347,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsSetSize_580348,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsUpdate_580370 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsUpdate_580372(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsUpdate_580371(
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
  var valid_580373 = path.getOrDefault("zone")
  valid_580373 = validateParameter(valid_580373, JString, required = true,
                                 default = nil)
  if valid_580373 != nil:
    section.add "zone", valid_580373
  var valid_580374 = path.getOrDefault("nodePoolId")
  valid_580374 = validateParameter(valid_580374, JString, required = true,
                                 default = nil)
  if valid_580374 != nil:
    section.add "nodePoolId", valid_580374
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
  var valid_580377 = query.getOrDefault("upload_protocol")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "upload_protocol", valid_580377
  var valid_580378 = query.getOrDefault("fields")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "fields", valid_580378
  var valid_580379 = query.getOrDefault("quotaUser")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "quotaUser", valid_580379
  var valid_580380 = query.getOrDefault("alt")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = newJString("json"))
  if valid_580380 != nil:
    section.add "alt", valid_580380
  var valid_580381 = query.getOrDefault("oauth_token")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "oauth_token", valid_580381
  var valid_580382 = query.getOrDefault("callback")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "callback", valid_580382
  var valid_580383 = query.getOrDefault("access_token")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "access_token", valid_580383
  var valid_580384 = query.getOrDefault("uploadType")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "uploadType", valid_580384
  var valid_580385 = query.getOrDefault("key")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "key", valid_580385
  var valid_580386 = query.getOrDefault("$.xgafv")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = newJString("1"))
  if valid_580386 != nil:
    section.add "$.xgafv", valid_580386
  var valid_580387 = query.getOrDefault("prettyPrint")
  valid_580387 = validateParameter(valid_580387, JBool, required = false,
                                 default = newJBool(true))
  if valid_580387 != nil:
    section.add "prettyPrint", valid_580387
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

proc call*(call_580389: Call_ContainerProjectsZonesClustersNodePoolsUpdate_580370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_580389.validator(path, query, header, formData, body)
  let scheme = call_580389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580389.url(scheme.get, call_580389.host, call_580389.base,
                         call_580389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580389, url, valid)

proc call*(call_580390: Call_ContainerProjectsZonesClustersNodePoolsUpdate_580370;
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
  var path_580391 = newJObject()
  var query_580392 = newJObject()
  var body_580393 = newJObject()
  add(query_580392, "upload_protocol", newJString(uploadProtocol))
  add(path_580391, "zone", newJString(zone))
  add(query_580392, "fields", newJString(fields))
  add(query_580392, "quotaUser", newJString(quotaUser))
  add(query_580392, "alt", newJString(alt))
  add(query_580392, "oauth_token", newJString(oauthToken))
  add(query_580392, "callback", newJString(callback))
  add(query_580392, "access_token", newJString(accessToken))
  add(query_580392, "uploadType", newJString(uploadType))
  add(path_580391, "nodePoolId", newJString(nodePoolId))
  add(query_580392, "key", newJString(key))
  add(path_580391, "projectId", newJString(projectId))
  add(query_580392, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580393 = body
  add(query_580392, "prettyPrint", newJBool(prettyPrint))
  add(path_580391, "clusterId", newJString(clusterId))
  result = call_580390.call(path_580391, query_580392, nil, nil, body_580393)

var containerProjectsZonesClustersNodePoolsUpdate* = Call_ContainerProjectsZonesClustersNodePoolsUpdate_580370(
    name: "containerProjectsZonesClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}/update",
    validator: validate_ContainerProjectsZonesClustersNodePoolsUpdate_580371,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsUpdate_580372,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersNodePoolsRollback_580394 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersNodePoolsRollback_580396(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersNodePoolsRollback_580395(
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
  var valid_580397 = path.getOrDefault("zone")
  valid_580397 = validateParameter(valid_580397, JString, required = true,
                                 default = nil)
  if valid_580397 != nil:
    section.add "zone", valid_580397
  var valid_580398 = path.getOrDefault("nodePoolId")
  valid_580398 = validateParameter(valid_580398, JString, required = true,
                                 default = nil)
  if valid_580398 != nil:
    section.add "nodePoolId", valid_580398
  var valid_580399 = path.getOrDefault("projectId")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "projectId", valid_580399
  var valid_580400 = path.getOrDefault("clusterId")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "clusterId", valid_580400
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
  var valid_580401 = query.getOrDefault("upload_protocol")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "upload_protocol", valid_580401
  var valid_580402 = query.getOrDefault("fields")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "fields", valid_580402
  var valid_580403 = query.getOrDefault("quotaUser")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "quotaUser", valid_580403
  var valid_580404 = query.getOrDefault("alt")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = newJString("json"))
  if valid_580404 != nil:
    section.add "alt", valid_580404
  var valid_580405 = query.getOrDefault("oauth_token")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "oauth_token", valid_580405
  var valid_580406 = query.getOrDefault("callback")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "callback", valid_580406
  var valid_580407 = query.getOrDefault("access_token")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "access_token", valid_580407
  var valid_580408 = query.getOrDefault("uploadType")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "uploadType", valid_580408
  var valid_580409 = query.getOrDefault("key")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "key", valid_580409
  var valid_580410 = query.getOrDefault("$.xgafv")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("1"))
  if valid_580410 != nil:
    section.add "$.xgafv", valid_580410
  var valid_580411 = query.getOrDefault("prettyPrint")
  valid_580411 = validateParameter(valid_580411, JBool, required = false,
                                 default = newJBool(true))
  if valid_580411 != nil:
    section.add "prettyPrint", valid_580411
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

proc call*(call_580413: Call_ContainerProjectsZonesClustersNodePoolsRollback_580394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_580413.validator(path, query, header, formData, body)
  let scheme = call_580413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580413.url(scheme.get, call_580413.host, call_580413.base,
                         call_580413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580413, url, valid)

proc call*(call_580414: Call_ContainerProjectsZonesClustersNodePoolsRollback_580394;
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
  var path_580415 = newJObject()
  var query_580416 = newJObject()
  var body_580417 = newJObject()
  add(query_580416, "upload_protocol", newJString(uploadProtocol))
  add(path_580415, "zone", newJString(zone))
  add(query_580416, "fields", newJString(fields))
  add(query_580416, "quotaUser", newJString(quotaUser))
  add(query_580416, "alt", newJString(alt))
  add(query_580416, "oauth_token", newJString(oauthToken))
  add(query_580416, "callback", newJString(callback))
  add(query_580416, "access_token", newJString(accessToken))
  add(query_580416, "uploadType", newJString(uploadType))
  add(path_580415, "nodePoolId", newJString(nodePoolId))
  add(query_580416, "key", newJString(key))
  add(path_580415, "projectId", newJString(projectId))
  add(query_580416, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580417 = body
  add(query_580416, "prettyPrint", newJBool(prettyPrint))
  add(path_580415, "clusterId", newJString(clusterId))
  result = call_580414.call(path_580415, query_580416, nil, nil, body_580417)

var containerProjectsZonesClustersNodePoolsRollback* = Call_ContainerProjectsZonesClustersNodePoolsRollback_580394(
    name: "containerProjectsZonesClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/nodePools/{nodePoolId}:rollback",
    validator: validate_ContainerProjectsZonesClustersNodePoolsRollback_580395,
    base: "/", url: url_ContainerProjectsZonesClustersNodePoolsRollback_580396,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersResourceLabels_580418 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersResourceLabels_580420(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersResourceLabels_580419(path: JsonNode;
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
  var valid_580421 = path.getOrDefault("zone")
  valid_580421 = validateParameter(valid_580421, JString, required = true,
                                 default = nil)
  if valid_580421 != nil:
    section.add "zone", valid_580421
  var valid_580422 = path.getOrDefault("projectId")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "projectId", valid_580422
  var valid_580423 = path.getOrDefault("clusterId")
  valid_580423 = validateParameter(valid_580423, JString, required = true,
                                 default = nil)
  if valid_580423 != nil:
    section.add "clusterId", valid_580423
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
  var valid_580424 = query.getOrDefault("upload_protocol")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "upload_protocol", valid_580424
  var valid_580425 = query.getOrDefault("fields")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "fields", valid_580425
  var valid_580426 = query.getOrDefault("quotaUser")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "quotaUser", valid_580426
  var valid_580427 = query.getOrDefault("alt")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = newJString("json"))
  if valid_580427 != nil:
    section.add "alt", valid_580427
  var valid_580428 = query.getOrDefault("oauth_token")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "oauth_token", valid_580428
  var valid_580429 = query.getOrDefault("callback")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "callback", valid_580429
  var valid_580430 = query.getOrDefault("access_token")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "access_token", valid_580430
  var valid_580431 = query.getOrDefault("uploadType")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "uploadType", valid_580431
  var valid_580432 = query.getOrDefault("key")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "key", valid_580432
  var valid_580433 = query.getOrDefault("$.xgafv")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("1"))
  if valid_580433 != nil:
    section.add "$.xgafv", valid_580433
  var valid_580434 = query.getOrDefault("prettyPrint")
  valid_580434 = validateParameter(valid_580434, JBool, required = false,
                                 default = newJBool(true))
  if valid_580434 != nil:
    section.add "prettyPrint", valid_580434
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

proc call*(call_580436: Call_ContainerProjectsZonesClustersResourceLabels_580418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_580436.validator(path, query, header, formData, body)
  let scheme = call_580436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580436.url(scheme.get, call_580436.host, call_580436.base,
                         call_580436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580436, url, valid)

proc call*(call_580437: Call_ContainerProjectsZonesClustersResourceLabels_580418;
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
  var path_580438 = newJObject()
  var query_580439 = newJObject()
  var body_580440 = newJObject()
  add(query_580439, "upload_protocol", newJString(uploadProtocol))
  add(path_580438, "zone", newJString(zone))
  add(query_580439, "fields", newJString(fields))
  add(query_580439, "quotaUser", newJString(quotaUser))
  add(query_580439, "alt", newJString(alt))
  add(query_580439, "oauth_token", newJString(oauthToken))
  add(query_580439, "callback", newJString(callback))
  add(query_580439, "access_token", newJString(accessToken))
  add(query_580439, "uploadType", newJString(uploadType))
  add(query_580439, "key", newJString(key))
  add(path_580438, "projectId", newJString(projectId))
  add(query_580439, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580440 = body
  add(query_580439, "prettyPrint", newJBool(prettyPrint))
  add(path_580438, "clusterId", newJString(clusterId))
  result = call_580437.call(path_580438, query_580439, nil, nil, body_580440)

var containerProjectsZonesClustersResourceLabels* = Call_ContainerProjectsZonesClustersResourceLabels_580418(
    name: "containerProjectsZonesClustersResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}/resourceLabels",
    validator: validate_ContainerProjectsZonesClustersResourceLabels_580419,
    base: "/", url: url_ContainerProjectsZonesClustersResourceLabels_580420,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersCompleteIpRotation_580441 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersCompleteIpRotation_580443(
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

proc validate_ContainerProjectsZonesClustersCompleteIpRotation_580442(
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
  var valid_580444 = path.getOrDefault("zone")
  valid_580444 = validateParameter(valid_580444, JString, required = true,
                                 default = nil)
  if valid_580444 != nil:
    section.add "zone", valid_580444
  var valid_580445 = path.getOrDefault("projectId")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "projectId", valid_580445
  var valid_580446 = path.getOrDefault("clusterId")
  valid_580446 = validateParameter(valid_580446, JString, required = true,
                                 default = nil)
  if valid_580446 != nil:
    section.add "clusterId", valid_580446
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
  var valid_580447 = query.getOrDefault("upload_protocol")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "upload_protocol", valid_580447
  var valid_580448 = query.getOrDefault("fields")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "fields", valid_580448
  var valid_580449 = query.getOrDefault("quotaUser")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "quotaUser", valid_580449
  var valid_580450 = query.getOrDefault("alt")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = newJString("json"))
  if valid_580450 != nil:
    section.add "alt", valid_580450
  var valid_580451 = query.getOrDefault("oauth_token")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "oauth_token", valid_580451
  var valid_580452 = query.getOrDefault("callback")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "callback", valid_580452
  var valid_580453 = query.getOrDefault("access_token")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "access_token", valid_580453
  var valid_580454 = query.getOrDefault("uploadType")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "uploadType", valid_580454
  var valid_580455 = query.getOrDefault("key")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "key", valid_580455
  var valid_580456 = query.getOrDefault("$.xgafv")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = newJString("1"))
  if valid_580456 != nil:
    section.add "$.xgafv", valid_580456
  var valid_580457 = query.getOrDefault("prettyPrint")
  valid_580457 = validateParameter(valid_580457, JBool, required = false,
                                 default = newJBool(true))
  if valid_580457 != nil:
    section.add "prettyPrint", valid_580457
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

proc call*(call_580459: Call_ContainerProjectsZonesClustersCompleteIpRotation_580441;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_580459.validator(path, query, header, formData, body)
  let scheme = call_580459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580459.url(scheme.get, call_580459.host, call_580459.base,
                         call_580459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580459, url, valid)

proc call*(call_580460: Call_ContainerProjectsZonesClustersCompleteIpRotation_580441;
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
  var path_580461 = newJObject()
  var query_580462 = newJObject()
  var body_580463 = newJObject()
  add(query_580462, "upload_protocol", newJString(uploadProtocol))
  add(path_580461, "zone", newJString(zone))
  add(query_580462, "fields", newJString(fields))
  add(query_580462, "quotaUser", newJString(quotaUser))
  add(query_580462, "alt", newJString(alt))
  add(query_580462, "oauth_token", newJString(oauthToken))
  add(query_580462, "callback", newJString(callback))
  add(query_580462, "access_token", newJString(accessToken))
  add(query_580462, "uploadType", newJString(uploadType))
  add(query_580462, "key", newJString(key))
  add(path_580461, "projectId", newJString(projectId))
  add(query_580462, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580463 = body
  add(query_580462, "prettyPrint", newJBool(prettyPrint))
  add(path_580461, "clusterId", newJString(clusterId))
  result = call_580460.call(path_580461, query_580462, nil, nil, body_580463)

var containerProjectsZonesClustersCompleteIpRotation* = Call_ContainerProjectsZonesClustersCompleteIpRotation_580441(
    name: "containerProjectsZonesClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:completeIpRotation",
    validator: validate_ContainerProjectsZonesClustersCompleteIpRotation_580442,
    base: "/", url: url_ContainerProjectsZonesClustersCompleteIpRotation_580443,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580464 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersSetMaintenancePolicy_580466(
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

proc validate_ContainerProjectsZonesClustersSetMaintenancePolicy_580465(
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
  var valid_580467 = path.getOrDefault("zone")
  valid_580467 = validateParameter(valid_580467, JString, required = true,
                                 default = nil)
  if valid_580467 != nil:
    section.add "zone", valid_580467
  var valid_580468 = path.getOrDefault("projectId")
  valid_580468 = validateParameter(valid_580468, JString, required = true,
                                 default = nil)
  if valid_580468 != nil:
    section.add "projectId", valid_580468
  var valid_580469 = path.getOrDefault("clusterId")
  valid_580469 = validateParameter(valid_580469, JString, required = true,
                                 default = nil)
  if valid_580469 != nil:
    section.add "clusterId", valid_580469
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
  var valid_580470 = query.getOrDefault("upload_protocol")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "upload_protocol", valid_580470
  var valid_580471 = query.getOrDefault("fields")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "fields", valid_580471
  var valid_580472 = query.getOrDefault("quotaUser")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "quotaUser", valid_580472
  var valid_580473 = query.getOrDefault("alt")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = newJString("json"))
  if valid_580473 != nil:
    section.add "alt", valid_580473
  var valid_580474 = query.getOrDefault("oauth_token")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "oauth_token", valid_580474
  var valid_580475 = query.getOrDefault("callback")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "callback", valid_580475
  var valid_580476 = query.getOrDefault("access_token")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "access_token", valid_580476
  var valid_580477 = query.getOrDefault("uploadType")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "uploadType", valid_580477
  var valid_580478 = query.getOrDefault("key")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "key", valid_580478
  var valid_580479 = query.getOrDefault("$.xgafv")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = newJString("1"))
  if valid_580479 != nil:
    section.add "$.xgafv", valid_580479
  var valid_580480 = query.getOrDefault("prettyPrint")
  valid_580480 = validateParameter(valid_580480, JBool, required = false,
                                 default = newJBool(true))
  if valid_580480 != nil:
    section.add "prettyPrint", valid_580480
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

proc call*(call_580482: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580464;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_580482.validator(path, query, header, formData, body)
  let scheme = call_580482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580482.url(scheme.get, call_580482.host, call_580482.base,
                         call_580482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580482, url, valid)

proc call*(call_580483: Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580464;
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
  var path_580484 = newJObject()
  var query_580485 = newJObject()
  var body_580486 = newJObject()
  add(query_580485, "upload_protocol", newJString(uploadProtocol))
  add(path_580484, "zone", newJString(zone))
  add(query_580485, "fields", newJString(fields))
  add(query_580485, "quotaUser", newJString(quotaUser))
  add(query_580485, "alt", newJString(alt))
  add(query_580485, "oauth_token", newJString(oauthToken))
  add(query_580485, "callback", newJString(callback))
  add(query_580485, "access_token", newJString(accessToken))
  add(query_580485, "uploadType", newJString(uploadType))
  add(query_580485, "key", newJString(key))
  add(path_580484, "projectId", newJString(projectId))
  add(query_580485, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580486 = body
  add(query_580485, "prettyPrint", newJBool(prettyPrint))
  add(path_580484, "clusterId", newJString(clusterId))
  result = call_580483.call(path_580484, query_580485, nil, nil, body_580486)

var containerProjectsZonesClustersSetMaintenancePolicy* = Call_ContainerProjectsZonesClustersSetMaintenancePolicy_580464(
    name: "containerProjectsZonesClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMaintenancePolicy",
    validator: validate_ContainerProjectsZonesClustersSetMaintenancePolicy_580465,
    base: "/", url: url_ContainerProjectsZonesClustersSetMaintenancePolicy_580466,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetMasterAuth_580487 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersSetMasterAuth_580489(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersSetMasterAuth_580488(path: JsonNode;
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
  var valid_580490 = path.getOrDefault("zone")
  valid_580490 = validateParameter(valid_580490, JString, required = true,
                                 default = nil)
  if valid_580490 != nil:
    section.add "zone", valid_580490
  var valid_580491 = path.getOrDefault("projectId")
  valid_580491 = validateParameter(valid_580491, JString, required = true,
                                 default = nil)
  if valid_580491 != nil:
    section.add "projectId", valid_580491
  var valid_580492 = path.getOrDefault("clusterId")
  valid_580492 = validateParameter(valid_580492, JString, required = true,
                                 default = nil)
  if valid_580492 != nil:
    section.add "clusterId", valid_580492
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
  var valid_580493 = query.getOrDefault("upload_protocol")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "upload_protocol", valid_580493
  var valid_580494 = query.getOrDefault("fields")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "fields", valid_580494
  var valid_580495 = query.getOrDefault("quotaUser")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "quotaUser", valid_580495
  var valid_580496 = query.getOrDefault("alt")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = newJString("json"))
  if valid_580496 != nil:
    section.add "alt", valid_580496
  var valid_580497 = query.getOrDefault("oauth_token")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "oauth_token", valid_580497
  var valid_580498 = query.getOrDefault("callback")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "callback", valid_580498
  var valid_580499 = query.getOrDefault("access_token")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "access_token", valid_580499
  var valid_580500 = query.getOrDefault("uploadType")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "uploadType", valid_580500
  var valid_580501 = query.getOrDefault("key")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "key", valid_580501
  var valid_580502 = query.getOrDefault("$.xgafv")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = newJString("1"))
  if valid_580502 != nil:
    section.add "$.xgafv", valid_580502
  var valid_580503 = query.getOrDefault("prettyPrint")
  valid_580503 = validateParameter(valid_580503, JBool, required = false,
                                 default = newJBool(true))
  if valid_580503 != nil:
    section.add "prettyPrint", valid_580503
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

proc call*(call_580505: Call_ContainerProjectsZonesClustersSetMasterAuth_580487;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_580505.validator(path, query, header, formData, body)
  let scheme = call_580505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580505.url(scheme.get, call_580505.host, call_580505.base,
                         call_580505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580505, url, valid)

proc call*(call_580506: Call_ContainerProjectsZonesClustersSetMasterAuth_580487;
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
  var path_580507 = newJObject()
  var query_580508 = newJObject()
  var body_580509 = newJObject()
  add(query_580508, "upload_protocol", newJString(uploadProtocol))
  add(path_580507, "zone", newJString(zone))
  add(query_580508, "fields", newJString(fields))
  add(query_580508, "quotaUser", newJString(quotaUser))
  add(query_580508, "alt", newJString(alt))
  add(query_580508, "oauth_token", newJString(oauthToken))
  add(query_580508, "callback", newJString(callback))
  add(query_580508, "access_token", newJString(accessToken))
  add(query_580508, "uploadType", newJString(uploadType))
  add(query_580508, "key", newJString(key))
  add(path_580507, "projectId", newJString(projectId))
  add(query_580508, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580509 = body
  add(query_580508, "prettyPrint", newJBool(prettyPrint))
  add(path_580507, "clusterId", newJString(clusterId))
  result = call_580506.call(path_580507, query_580508, nil, nil, body_580509)

var containerProjectsZonesClustersSetMasterAuth* = Call_ContainerProjectsZonesClustersSetMasterAuth_580487(
    name: "containerProjectsZonesClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setMasterAuth",
    validator: validate_ContainerProjectsZonesClustersSetMasterAuth_580488,
    base: "/", url: url_ContainerProjectsZonesClustersSetMasterAuth_580489,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersSetNetworkPolicy_580510 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersSetNetworkPolicy_580512(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersSetNetworkPolicy_580511(
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
  var valid_580513 = path.getOrDefault("zone")
  valid_580513 = validateParameter(valid_580513, JString, required = true,
                                 default = nil)
  if valid_580513 != nil:
    section.add "zone", valid_580513
  var valid_580514 = path.getOrDefault("projectId")
  valid_580514 = validateParameter(valid_580514, JString, required = true,
                                 default = nil)
  if valid_580514 != nil:
    section.add "projectId", valid_580514
  var valid_580515 = path.getOrDefault("clusterId")
  valid_580515 = validateParameter(valid_580515, JString, required = true,
                                 default = nil)
  if valid_580515 != nil:
    section.add "clusterId", valid_580515
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
  var valid_580516 = query.getOrDefault("upload_protocol")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "upload_protocol", valid_580516
  var valid_580517 = query.getOrDefault("fields")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "fields", valid_580517
  var valid_580518 = query.getOrDefault("quotaUser")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "quotaUser", valid_580518
  var valid_580519 = query.getOrDefault("alt")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = newJString("json"))
  if valid_580519 != nil:
    section.add "alt", valid_580519
  var valid_580520 = query.getOrDefault("oauth_token")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "oauth_token", valid_580520
  var valid_580521 = query.getOrDefault("callback")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "callback", valid_580521
  var valid_580522 = query.getOrDefault("access_token")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "access_token", valid_580522
  var valid_580523 = query.getOrDefault("uploadType")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "uploadType", valid_580523
  var valid_580524 = query.getOrDefault("key")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "key", valid_580524
  var valid_580525 = query.getOrDefault("$.xgafv")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = newJString("1"))
  if valid_580525 != nil:
    section.add "$.xgafv", valid_580525
  var valid_580526 = query.getOrDefault("prettyPrint")
  valid_580526 = validateParameter(valid_580526, JBool, required = false,
                                 default = newJBool(true))
  if valid_580526 != nil:
    section.add "prettyPrint", valid_580526
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

proc call*(call_580528: Call_ContainerProjectsZonesClustersSetNetworkPolicy_580510;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_580528.validator(path, query, header, formData, body)
  let scheme = call_580528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580528.url(scheme.get, call_580528.host, call_580528.base,
                         call_580528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580528, url, valid)

proc call*(call_580529: Call_ContainerProjectsZonesClustersSetNetworkPolicy_580510;
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
  var path_580530 = newJObject()
  var query_580531 = newJObject()
  var body_580532 = newJObject()
  add(query_580531, "upload_protocol", newJString(uploadProtocol))
  add(path_580530, "zone", newJString(zone))
  add(query_580531, "fields", newJString(fields))
  add(query_580531, "quotaUser", newJString(quotaUser))
  add(query_580531, "alt", newJString(alt))
  add(query_580531, "oauth_token", newJString(oauthToken))
  add(query_580531, "callback", newJString(callback))
  add(query_580531, "access_token", newJString(accessToken))
  add(query_580531, "uploadType", newJString(uploadType))
  add(query_580531, "key", newJString(key))
  add(path_580530, "projectId", newJString(projectId))
  add(query_580531, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580532 = body
  add(query_580531, "prettyPrint", newJBool(prettyPrint))
  add(path_580530, "clusterId", newJString(clusterId))
  result = call_580529.call(path_580530, query_580531, nil, nil, body_580532)

var containerProjectsZonesClustersSetNetworkPolicy* = Call_ContainerProjectsZonesClustersSetNetworkPolicy_580510(
    name: "containerProjectsZonesClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:setNetworkPolicy",
    validator: validate_ContainerProjectsZonesClustersSetNetworkPolicy_580511,
    base: "/", url: url_ContainerProjectsZonesClustersSetNetworkPolicy_580512,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesClustersStartIpRotation_580533 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesClustersStartIpRotation_580535(protocol: Scheme;
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

proc validate_ContainerProjectsZonesClustersStartIpRotation_580534(
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
  var valid_580536 = path.getOrDefault("zone")
  valid_580536 = validateParameter(valid_580536, JString, required = true,
                                 default = nil)
  if valid_580536 != nil:
    section.add "zone", valid_580536
  var valid_580537 = path.getOrDefault("projectId")
  valid_580537 = validateParameter(valid_580537, JString, required = true,
                                 default = nil)
  if valid_580537 != nil:
    section.add "projectId", valid_580537
  var valid_580538 = path.getOrDefault("clusterId")
  valid_580538 = validateParameter(valid_580538, JString, required = true,
                                 default = nil)
  if valid_580538 != nil:
    section.add "clusterId", valid_580538
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
  var valid_580539 = query.getOrDefault("upload_protocol")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "upload_protocol", valid_580539
  var valid_580540 = query.getOrDefault("fields")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "fields", valid_580540
  var valid_580541 = query.getOrDefault("quotaUser")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "quotaUser", valid_580541
  var valid_580542 = query.getOrDefault("alt")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = newJString("json"))
  if valid_580542 != nil:
    section.add "alt", valid_580542
  var valid_580543 = query.getOrDefault("oauth_token")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "oauth_token", valid_580543
  var valid_580544 = query.getOrDefault("callback")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "callback", valid_580544
  var valid_580545 = query.getOrDefault("access_token")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "access_token", valid_580545
  var valid_580546 = query.getOrDefault("uploadType")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "uploadType", valid_580546
  var valid_580547 = query.getOrDefault("key")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "key", valid_580547
  var valid_580548 = query.getOrDefault("$.xgafv")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = newJString("1"))
  if valid_580548 != nil:
    section.add "$.xgafv", valid_580548
  var valid_580549 = query.getOrDefault("prettyPrint")
  valid_580549 = validateParameter(valid_580549, JBool, required = false,
                                 default = newJBool(true))
  if valid_580549 != nil:
    section.add "prettyPrint", valid_580549
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

proc call*(call_580551: Call_ContainerProjectsZonesClustersStartIpRotation_580533;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_580551.validator(path, query, header, formData, body)
  let scheme = call_580551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580551.url(scheme.get, call_580551.host, call_580551.base,
                         call_580551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580551, url, valid)

proc call*(call_580552: Call_ContainerProjectsZonesClustersStartIpRotation_580533;
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
  var path_580553 = newJObject()
  var query_580554 = newJObject()
  var body_580555 = newJObject()
  add(query_580554, "upload_protocol", newJString(uploadProtocol))
  add(path_580553, "zone", newJString(zone))
  add(query_580554, "fields", newJString(fields))
  add(query_580554, "quotaUser", newJString(quotaUser))
  add(query_580554, "alt", newJString(alt))
  add(query_580554, "oauth_token", newJString(oauthToken))
  add(query_580554, "callback", newJString(callback))
  add(query_580554, "access_token", newJString(accessToken))
  add(query_580554, "uploadType", newJString(uploadType))
  add(query_580554, "key", newJString(key))
  add(path_580553, "projectId", newJString(projectId))
  add(query_580554, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580555 = body
  add(query_580554, "prettyPrint", newJBool(prettyPrint))
  add(path_580553, "clusterId", newJString(clusterId))
  result = call_580552.call(path_580553, query_580554, nil, nil, body_580555)

var containerProjectsZonesClustersStartIpRotation* = Call_ContainerProjectsZonesClustersStartIpRotation_580533(
    name: "containerProjectsZonesClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/clusters/{clusterId}:startIpRotation",
    validator: validate_ContainerProjectsZonesClustersStartIpRotation_580534,
    base: "/", url: url_ContainerProjectsZonesClustersStartIpRotation_580535,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsList_580556 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesOperationsList_580558(protocol: Scheme;
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

proc validate_ContainerProjectsZonesOperationsList_580557(path: JsonNode;
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
  var valid_580559 = path.getOrDefault("zone")
  valid_580559 = validateParameter(valid_580559, JString, required = true,
                                 default = nil)
  if valid_580559 != nil:
    section.add "zone", valid_580559
  var valid_580560 = path.getOrDefault("projectId")
  valid_580560 = validateParameter(valid_580560, JString, required = true,
                                 default = nil)
  if valid_580560 != nil:
    section.add "projectId", valid_580560
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
  var valid_580561 = query.getOrDefault("upload_protocol")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "upload_protocol", valid_580561
  var valid_580562 = query.getOrDefault("fields")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "fields", valid_580562
  var valid_580563 = query.getOrDefault("quotaUser")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "quotaUser", valid_580563
  var valid_580564 = query.getOrDefault("alt")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = newJString("json"))
  if valid_580564 != nil:
    section.add "alt", valid_580564
  var valid_580565 = query.getOrDefault("oauth_token")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "oauth_token", valid_580565
  var valid_580566 = query.getOrDefault("callback")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "callback", valid_580566
  var valid_580567 = query.getOrDefault("access_token")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "access_token", valid_580567
  var valid_580568 = query.getOrDefault("uploadType")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "uploadType", valid_580568
  var valid_580569 = query.getOrDefault("parent")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "parent", valid_580569
  var valid_580570 = query.getOrDefault("key")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "key", valid_580570
  var valid_580571 = query.getOrDefault("$.xgafv")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = newJString("1"))
  if valid_580571 != nil:
    section.add "$.xgafv", valid_580571
  var valid_580572 = query.getOrDefault("prettyPrint")
  valid_580572 = validateParameter(valid_580572, JBool, required = false,
                                 default = newJBool(true))
  if valid_580572 != nil:
    section.add "prettyPrint", valid_580572
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580573: Call_ContainerProjectsZonesOperationsList_580556;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_580573.validator(path, query, header, formData, body)
  let scheme = call_580573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580573.url(scheme.get, call_580573.host, call_580573.base,
                         call_580573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580573, url, valid)

proc call*(call_580574: Call_ContainerProjectsZonesOperationsList_580556;
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
  var path_580575 = newJObject()
  var query_580576 = newJObject()
  add(query_580576, "upload_protocol", newJString(uploadProtocol))
  add(path_580575, "zone", newJString(zone))
  add(query_580576, "fields", newJString(fields))
  add(query_580576, "quotaUser", newJString(quotaUser))
  add(query_580576, "alt", newJString(alt))
  add(query_580576, "oauth_token", newJString(oauthToken))
  add(query_580576, "callback", newJString(callback))
  add(query_580576, "access_token", newJString(accessToken))
  add(query_580576, "uploadType", newJString(uploadType))
  add(query_580576, "parent", newJString(parent))
  add(query_580576, "key", newJString(key))
  add(path_580575, "projectId", newJString(projectId))
  add(query_580576, "$.xgafv", newJString(Xgafv))
  add(query_580576, "prettyPrint", newJBool(prettyPrint))
  result = call_580574.call(path_580575, query_580576, nil, nil, nil)

var containerProjectsZonesOperationsList* = Call_ContainerProjectsZonesOperationsList_580556(
    name: "containerProjectsZonesOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations",
    validator: validate_ContainerProjectsZonesOperationsList_580557, base: "/",
    url: url_ContainerProjectsZonesOperationsList_580558, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsGet_580577 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesOperationsGet_580579(protocol: Scheme; host: string;
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

proc validate_ContainerProjectsZonesOperationsGet_580578(path: JsonNode;
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
  var valid_580580 = path.getOrDefault("zone")
  valid_580580 = validateParameter(valid_580580, JString, required = true,
                                 default = nil)
  if valid_580580 != nil:
    section.add "zone", valid_580580
  var valid_580581 = path.getOrDefault("projectId")
  valid_580581 = validateParameter(valid_580581, JString, required = true,
                                 default = nil)
  if valid_580581 != nil:
    section.add "projectId", valid_580581
  var valid_580582 = path.getOrDefault("operationId")
  valid_580582 = validateParameter(valid_580582, JString, required = true,
                                 default = nil)
  if valid_580582 != nil:
    section.add "operationId", valid_580582
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
  var valid_580583 = query.getOrDefault("upload_protocol")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "upload_protocol", valid_580583
  var valid_580584 = query.getOrDefault("fields")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "fields", valid_580584
  var valid_580585 = query.getOrDefault("quotaUser")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "quotaUser", valid_580585
  var valid_580586 = query.getOrDefault("alt")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = newJString("json"))
  if valid_580586 != nil:
    section.add "alt", valid_580586
  var valid_580587 = query.getOrDefault("oauth_token")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "oauth_token", valid_580587
  var valid_580588 = query.getOrDefault("callback")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "callback", valid_580588
  var valid_580589 = query.getOrDefault("access_token")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "access_token", valid_580589
  var valid_580590 = query.getOrDefault("uploadType")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "uploadType", valid_580590
  var valid_580591 = query.getOrDefault("key")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "key", valid_580591
  var valid_580592 = query.getOrDefault("name")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "name", valid_580592
  var valid_580593 = query.getOrDefault("$.xgafv")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = newJString("1"))
  if valid_580593 != nil:
    section.add "$.xgafv", valid_580593
  var valid_580594 = query.getOrDefault("prettyPrint")
  valid_580594 = validateParameter(valid_580594, JBool, required = false,
                                 default = newJBool(true))
  if valid_580594 != nil:
    section.add "prettyPrint", valid_580594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580595: Call_ContainerProjectsZonesOperationsGet_580577;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified operation.
  ## 
  let valid = call_580595.validator(path, query, header, formData, body)
  let scheme = call_580595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580595.url(scheme.get, call_580595.host, call_580595.base,
                         call_580595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580595, url, valid)

proc call*(call_580596: Call_ContainerProjectsZonesOperationsGet_580577;
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
  var path_580597 = newJObject()
  var query_580598 = newJObject()
  add(query_580598, "upload_protocol", newJString(uploadProtocol))
  add(path_580597, "zone", newJString(zone))
  add(query_580598, "fields", newJString(fields))
  add(query_580598, "quotaUser", newJString(quotaUser))
  add(query_580598, "alt", newJString(alt))
  add(query_580598, "oauth_token", newJString(oauthToken))
  add(query_580598, "callback", newJString(callback))
  add(query_580598, "access_token", newJString(accessToken))
  add(query_580598, "uploadType", newJString(uploadType))
  add(query_580598, "key", newJString(key))
  add(query_580598, "name", newJString(name))
  add(path_580597, "projectId", newJString(projectId))
  add(query_580598, "$.xgafv", newJString(Xgafv))
  add(query_580598, "prettyPrint", newJBool(prettyPrint))
  add(path_580597, "operationId", newJString(operationId))
  result = call_580596.call(path_580597, query_580598, nil, nil, nil)

var containerProjectsZonesOperationsGet* = Call_ContainerProjectsZonesOperationsGet_580577(
    name: "containerProjectsZonesOperationsGet", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}",
    validator: validate_ContainerProjectsZonesOperationsGet_580578, base: "/",
    url: url_ContainerProjectsZonesOperationsGet_580579, schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesOperationsCancel_580599 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesOperationsCancel_580601(protocol: Scheme;
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

proc validate_ContainerProjectsZonesOperationsCancel_580600(path: JsonNode;
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
  var valid_580602 = path.getOrDefault("zone")
  valid_580602 = validateParameter(valid_580602, JString, required = true,
                                 default = nil)
  if valid_580602 != nil:
    section.add "zone", valid_580602
  var valid_580603 = path.getOrDefault("projectId")
  valid_580603 = validateParameter(valid_580603, JString, required = true,
                                 default = nil)
  if valid_580603 != nil:
    section.add "projectId", valid_580603
  var valid_580604 = path.getOrDefault("operationId")
  valid_580604 = validateParameter(valid_580604, JString, required = true,
                                 default = nil)
  if valid_580604 != nil:
    section.add "operationId", valid_580604
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
  var valid_580605 = query.getOrDefault("upload_protocol")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "upload_protocol", valid_580605
  var valid_580606 = query.getOrDefault("fields")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "fields", valid_580606
  var valid_580607 = query.getOrDefault("quotaUser")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "quotaUser", valid_580607
  var valid_580608 = query.getOrDefault("alt")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = newJString("json"))
  if valid_580608 != nil:
    section.add "alt", valid_580608
  var valid_580609 = query.getOrDefault("oauth_token")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "oauth_token", valid_580609
  var valid_580610 = query.getOrDefault("callback")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "callback", valid_580610
  var valid_580611 = query.getOrDefault("access_token")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "access_token", valid_580611
  var valid_580612 = query.getOrDefault("uploadType")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "uploadType", valid_580612
  var valid_580613 = query.getOrDefault("key")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "key", valid_580613
  var valid_580614 = query.getOrDefault("$.xgafv")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = newJString("1"))
  if valid_580614 != nil:
    section.add "$.xgafv", valid_580614
  var valid_580615 = query.getOrDefault("prettyPrint")
  valid_580615 = validateParameter(valid_580615, JBool, required = false,
                                 default = newJBool(true))
  if valid_580615 != nil:
    section.add "prettyPrint", valid_580615
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

proc call*(call_580617: Call_ContainerProjectsZonesOperationsCancel_580599;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_580617.validator(path, query, header, formData, body)
  let scheme = call_580617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580617.url(scheme.get, call_580617.host, call_580617.base,
                         call_580617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580617, url, valid)

proc call*(call_580618: Call_ContainerProjectsZonesOperationsCancel_580599;
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
  var path_580619 = newJObject()
  var query_580620 = newJObject()
  var body_580621 = newJObject()
  add(query_580620, "upload_protocol", newJString(uploadProtocol))
  add(path_580619, "zone", newJString(zone))
  add(query_580620, "fields", newJString(fields))
  add(query_580620, "quotaUser", newJString(quotaUser))
  add(query_580620, "alt", newJString(alt))
  add(query_580620, "oauth_token", newJString(oauthToken))
  add(query_580620, "callback", newJString(callback))
  add(query_580620, "access_token", newJString(accessToken))
  add(query_580620, "uploadType", newJString(uploadType))
  add(query_580620, "key", newJString(key))
  add(path_580619, "projectId", newJString(projectId))
  add(query_580620, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580621 = body
  add(query_580620, "prettyPrint", newJBool(prettyPrint))
  add(path_580619, "operationId", newJString(operationId))
  result = call_580618.call(path_580619, query_580620, nil, nil, body_580621)

var containerProjectsZonesOperationsCancel* = Call_ContainerProjectsZonesOperationsCancel_580599(
    name: "containerProjectsZonesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/projects/{projectId}/zones/{zone}/operations/{operationId}:cancel",
    validator: validate_ContainerProjectsZonesOperationsCancel_580600, base: "/",
    url: url_ContainerProjectsZonesOperationsCancel_580601,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsZonesGetServerconfig_580622 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsZonesGetServerconfig_580624(protocol: Scheme;
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

proc validate_ContainerProjectsZonesGetServerconfig_580623(path: JsonNode;
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
  var valid_580625 = path.getOrDefault("zone")
  valid_580625 = validateParameter(valid_580625, JString, required = true,
                                 default = nil)
  if valid_580625 != nil:
    section.add "zone", valid_580625
  var valid_580626 = path.getOrDefault("projectId")
  valid_580626 = validateParameter(valid_580626, JString, required = true,
                                 default = nil)
  if valid_580626 != nil:
    section.add "projectId", valid_580626
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
  var valid_580627 = query.getOrDefault("upload_protocol")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "upload_protocol", valid_580627
  var valid_580628 = query.getOrDefault("fields")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "fields", valid_580628
  var valid_580629 = query.getOrDefault("quotaUser")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "quotaUser", valid_580629
  var valid_580630 = query.getOrDefault("alt")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = newJString("json"))
  if valid_580630 != nil:
    section.add "alt", valid_580630
  var valid_580631 = query.getOrDefault("oauth_token")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "oauth_token", valid_580631
  var valid_580632 = query.getOrDefault("callback")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "callback", valid_580632
  var valid_580633 = query.getOrDefault("access_token")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "access_token", valid_580633
  var valid_580634 = query.getOrDefault("uploadType")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "uploadType", valid_580634
  var valid_580635 = query.getOrDefault("key")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "key", valid_580635
  var valid_580636 = query.getOrDefault("name")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "name", valid_580636
  var valid_580637 = query.getOrDefault("$.xgafv")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = newJString("1"))
  if valid_580637 != nil:
    section.add "$.xgafv", valid_580637
  var valid_580638 = query.getOrDefault("prettyPrint")
  valid_580638 = validateParameter(valid_580638, JBool, required = false,
                                 default = newJBool(true))
  if valid_580638 != nil:
    section.add "prettyPrint", valid_580638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580639: Call_ContainerProjectsZonesGetServerconfig_580622;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_580639.validator(path, query, header, formData, body)
  let scheme = call_580639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580639.url(scheme.get, call_580639.host, call_580639.base,
                         call_580639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580639, url, valid)

proc call*(call_580640: Call_ContainerProjectsZonesGetServerconfig_580622;
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
  var path_580641 = newJObject()
  var query_580642 = newJObject()
  add(query_580642, "upload_protocol", newJString(uploadProtocol))
  add(path_580641, "zone", newJString(zone))
  add(query_580642, "fields", newJString(fields))
  add(query_580642, "quotaUser", newJString(quotaUser))
  add(query_580642, "alt", newJString(alt))
  add(query_580642, "oauth_token", newJString(oauthToken))
  add(query_580642, "callback", newJString(callback))
  add(query_580642, "access_token", newJString(accessToken))
  add(query_580642, "uploadType", newJString(uploadType))
  add(query_580642, "key", newJString(key))
  add(query_580642, "name", newJString(name))
  add(path_580641, "projectId", newJString(projectId))
  add(query_580642, "$.xgafv", newJString(Xgafv))
  add(query_580642, "prettyPrint", newJBool(prettyPrint))
  result = call_580640.call(path_580641, query_580642, nil, nil, nil)

var containerProjectsZonesGetServerconfig* = Call_ContainerProjectsZonesGetServerconfig_580622(
    name: "containerProjectsZonesGetServerconfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com",
    route: "/v1/projects/{projectId}/zones/{zone}/serverconfig",
    validator: validate_ContainerProjectsZonesGetServerconfig_580623, base: "/",
    url: url_ContainerProjectsZonesGetServerconfig_580624, schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580666 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsUpdate_580668(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsUpdate_580667(
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
  var valid_580669 = path.getOrDefault("name")
  valid_580669 = validateParameter(valid_580669, JString, required = true,
                                 default = nil)
  if valid_580669 != nil:
    section.add "name", valid_580669
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
  var valid_580670 = query.getOrDefault("upload_protocol")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "upload_protocol", valid_580670
  var valid_580671 = query.getOrDefault("fields")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "fields", valid_580671
  var valid_580672 = query.getOrDefault("quotaUser")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "quotaUser", valid_580672
  var valid_580673 = query.getOrDefault("alt")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = newJString("json"))
  if valid_580673 != nil:
    section.add "alt", valid_580673
  var valid_580674 = query.getOrDefault("oauth_token")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "oauth_token", valid_580674
  var valid_580675 = query.getOrDefault("callback")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "callback", valid_580675
  var valid_580676 = query.getOrDefault("access_token")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "access_token", valid_580676
  var valid_580677 = query.getOrDefault("uploadType")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "uploadType", valid_580677
  var valid_580678 = query.getOrDefault("key")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "key", valid_580678
  var valid_580679 = query.getOrDefault("$.xgafv")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = newJString("1"))
  if valid_580679 != nil:
    section.add "$.xgafv", valid_580679
  var valid_580680 = query.getOrDefault("prettyPrint")
  valid_580680 = validateParameter(valid_580680, JBool, required = false,
                                 default = newJBool(true))
  if valid_580680 != nil:
    section.add "prettyPrint", valid_580680
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

proc call*(call_580682: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580666;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the version and/or image type for the specified node pool.
  ## 
  let valid = call_580682.validator(path, query, header, formData, body)
  let scheme = call_580682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580682.url(scheme.get, call_580682.host, call_580682.base,
                         call_580682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580682, url, valid)

proc call*(call_580683: Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580666;
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
  var path_580684 = newJObject()
  var query_580685 = newJObject()
  var body_580686 = newJObject()
  add(query_580685, "upload_protocol", newJString(uploadProtocol))
  add(query_580685, "fields", newJString(fields))
  add(query_580685, "quotaUser", newJString(quotaUser))
  add(path_580684, "name", newJString(name))
  add(query_580685, "alt", newJString(alt))
  add(query_580685, "oauth_token", newJString(oauthToken))
  add(query_580685, "callback", newJString(callback))
  add(query_580685, "access_token", newJString(accessToken))
  add(query_580685, "uploadType", newJString(uploadType))
  add(query_580685, "key", newJString(key))
  add(query_580685, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580686 = body
  add(query_580685, "prettyPrint", newJBool(prettyPrint))
  result = call_580683.call(path_580684, query_580685, nil, nil, body_580686)

var containerProjectsLocationsClustersNodePoolsUpdate* = Call_ContainerProjectsLocationsClustersNodePoolsUpdate_580666(
    name: "containerProjectsLocationsClustersNodePoolsUpdate",
    meth: HttpMethod.HttpPut, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsUpdate_580667,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsUpdate_580668,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsGet_580643 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsGet_580645(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersNodePoolsGet_580644(
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
  var valid_580646 = path.getOrDefault("name")
  valid_580646 = validateParameter(valid_580646, JString, required = true,
                                 default = nil)
  if valid_580646 != nil:
    section.add "name", valid_580646
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
  var valid_580647 = query.getOrDefault("upload_protocol")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "upload_protocol", valid_580647
  var valid_580648 = query.getOrDefault("fields")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "fields", valid_580648
  var valid_580649 = query.getOrDefault("quotaUser")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "quotaUser", valid_580649
  var valid_580650 = query.getOrDefault("alt")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = newJString("json"))
  if valid_580650 != nil:
    section.add "alt", valid_580650
  var valid_580651 = query.getOrDefault("oauth_token")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "oauth_token", valid_580651
  var valid_580652 = query.getOrDefault("callback")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "callback", valid_580652
  var valid_580653 = query.getOrDefault("access_token")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "access_token", valid_580653
  var valid_580654 = query.getOrDefault("uploadType")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "uploadType", valid_580654
  var valid_580655 = query.getOrDefault("nodePoolId")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "nodePoolId", valid_580655
  var valid_580656 = query.getOrDefault("zone")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "zone", valid_580656
  var valid_580657 = query.getOrDefault("key")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "key", valid_580657
  var valid_580658 = query.getOrDefault("$.xgafv")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = newJString("1"))
  if valid_580658 != nil:
    section.add "$.xgafv", valid_580658
  var valid_580659 = query.getOrDefault("projectId")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "projectId", valid_580659
  var valid_580660 = query.getOrDefault("prettyPrint")
  valid_580660 = validateParameter(valid_580660, JBool, required = false,
                                 default = newJBool(true))
  if valid_580660 != nil:
    section.add "prettyPrint", valid_580660
  var valid_580661 = query.getOrDefault("clusterId")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "clusterId", valid_580661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580662: Call_ContainerProjectsLocationsClustersNodePoolsGet_580643;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the requested node pool.
  ## 
  let valid = call_580662.validator(path, query, header, formData, body)
  let scheme = call_580662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580662.url(scheme.get, call_580662.host, call_580662.base,
                         call_580662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580662, url, valid)

proc call*(call_580663: Call_ContainerProjectsLocationsClustersNodePoolsGet_580643;
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
  var path_580664 = newJObject()
  var query_580665 = newJObject()
  add(query_580665, "upload_protocol", newJString(uploadProtocol))
  add(query_580665, "fields", newJString(fields))
  add(query_580665, "quotaUser", newJString(quotaUser))
  add(path_580664, "name", newJString(name))
  add(query_580665, "alt", newJString(alt))
  add(query_580665, "oauth_token", newJString(oauthToken))
  add(query_580665, "callback", newJString(callback))
  add(query_580665, "access_token", newJString(accessToken))
  add(query_580665, "uploadType", newJString(uploadType))
  add(query_580665, "nodePoolId", newJString(nodePoolId))
  add(query_580665, "zone", newJString(zone))
  add(query_580665, "key", newJString(key))
  add(query_580665, "$.xgafv", newJString(Xgafv))
  add(query_580665, "projectId", newJString(projectId))
  add(query_580665, "prettyPrint", newJBool(prettyPrint))
  add(query_580665, "clusterId", newJString(clusterId))
  result = call_580663.call(path_580664, query_580665, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsGet* = Call_ContainerProjectsLocationsClustersNodePoolsGet_580643(
    name: "containerProjectsLocationsClustersNodePoolsGet",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com", route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsGet_580644,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsGet_580645,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsDelete_580687 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsDelete_580689(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsDelete_580688(
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
  var valid_580690 = path.getOrDefault("name")
  valid_580690 = validateParameter(valid_580690, JString, required = true,
                                 default = nil)
  if valid_580690 != nil:
    section.add "name", valid_580690
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
  var valid_580691 = query.getOrDefault("upload_protocol")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "upload_protocol", valid_580691
  var valid_580692 = query.getOrDefault("fields")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "fields", valid_580692
  var valid_580693 = query.getOrDefault("quotaUser")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "quotaUser", valid_580693
  var valid_580694 = query.getOrDefault("alt")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = newJString("json"))
  if valid_580694 != nil:
    section.add "alt", valid_580694
  var valid_580695 = query.getOrDefault("oauth_token")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "oauth_token", valid_580695
  var valid_580696 = query.getOrDefault("callback")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "callback", valid_580696
  var valid_580697 = query.getOrDefault("access_token")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "access_token", valid_580697
  var valid_580698 = query.getOrDefault("uploadType")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "uploadType", valid_580698
  var valid_580699 = query.getOrDefault("nodePoolId")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "nodePoolId", valid_580699
  var valid_580700 = query.getOrDefault("zone")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "zone", valid_580700
  var valid_580701 = query.getOrDefault("key")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "key", valid_580701
  var valid_580702 = query.getOrDefault("$.xgafv")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = newJString("1"))
  if valid_580702 != nil:
    section.add "$.xgafv", valid_580702
  var valid_580703 = query.getOrDefault("projectId")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "projectId", valid_580703
  var valid_580704 = query.getOrDefault("prettyPrint")
  valid_580704 = validateParameter(valid_580704, JBool, required = false,
                                 default = newJBool(true))
  if valid_580704 != nil:
    section.add "prettyPrint", valid_580704
  var valid_580705 = query.getOrDefault("clusterId")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "clusterId", valid_580705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580706: Call_ContainerProjectsLocationsClustersNodePoolsDelete_580687;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node pool from a cluster.
  ## 
  let valid = call_580706.validator(path, query, header, formData, body)
  let scheme = call_580706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580706.url(scheme.get, call_580706.host, call_580706.base,
                         call_580706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580706, url, valid)

proc call*(call_580707: Call_ContainerProjectsLocationsClustersNodePoolsDelete_580687;
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
  var path_580708 = newJObject()
  var query_580709 = newJObject()
  add(query_580709, "upload_protocol", newJString(uploadProtocol))
  add(query_580709, "fields", newJString(fields))
  add(query_580709, "quotaUser", newJString(quotaUser))
  add(path_580708, "name", newJString(name))
  add(query_580709, "alt", newJString(alt))
  add(query_580709, "oauth_token", newJString(oauthToken))
  add(query_580709, "callback", newJString(callback))
  add(query_580709, "access_token", newJString(accessToken))
  add(query_580709, "uploadType", newJString(uploadType))
  add(query_580709, "nodePoolId", newJString(nodePoolId))
  add(query_580709, "zone", newJString(zone))
  add(query_580709, "key", newJString(key))
  add(query_580709, "$.xgafv", newJString(Xgafv))
  add(query_580709, "projectId", newJString(projectId))
  add(query_580709, "prettyPrint", newJBool(prettyPrint))
  add(query_580709, "clusterId", newJString(clusterId))
  result = call_580707.call(path_580708, query_580709, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsDelete* = Call_ContainerProjectsLocationsClustersNodePoolsDelete_580687(
    name: "containerProjectsLocationsClustersNodePoolsDelete",
    meth: HttpMethod.HttpDelete, host: "container.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsDelete_580688,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsDelete_580689,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsGetServerConfig_580710 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsGetServerConfig_580712(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsGetServerConfig_580711(path: JsonNode;
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
  var valid_580713 = path.getOrDefault("name")
  valid_580713 = validateParameter(valid_580713, JString, required = true,
                                 default = nil)
  if valid_580713 != nil:
    section.add "name", valid_580713
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
  var valid_580714 = query.getOrDefault("upload_protocol")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "upload_protocol", valid_580714
  var valid_580715 = query.getOrDefault("fields")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "fields", valid_580715
  var valid_580716 = query.getOrDefault("quotaUser")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "quotaUser", valid_580716
  var valid_580717 = query.getOrDefault("alt")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = newJString("json"))
  if valid_580717 != nil:
    section.add "alt", valid_580717
  var valid_580718 = query.getOrDefault("oauth_token")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "oauth_token", valid_580718
  var valid_580719 = query.getOrDefault("callback")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "callback", valid_580719
  var valid_580720 = query.getOrDefault("access_token")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "access_token", valid_580720
  var valid_580721 = query.getOrDefault("uploadType")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "uploadType", valid_580721
  var valid_580722 = query.getOrDefault("zone")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "zone", valid_580722
  var valid_580723 = query.getOrDefault("key")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "key", valid_580723
  var valid_580724 = query.getOrDefault("$.xgafv")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = newJString("1"))
  if valid_580724 != nil:
    section.add "$.xgafv", valid_580724
  var valid_580725 = query.getOrDefault("projectId")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "projectId", valid_580725
  var valid_580726 = query.getOrDefault("prettyPrint")
  valid_580726 = validateParameter(valid_580726, JBool, required = false,
                                 default = newJBool(true))
  if valid_580726 != nil:
    section.add "prettyPrint", valid_580726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580727: Call_ContainerProjectsLocationsGetServerConfig_580710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns configuration info about the Google Kubernetes Engine service.
  ## 
  let valid = call_580727.validator(path, query, header, formData, body)
  let scheme = call_580727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580727.url(scheme.get, call_580727.host, call_580727.base,
                         call_580727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580727, url, valid)

proc call*(call_580728: Call_ContainerProjectsLocationsGetServerConfig_580710;
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
  var path_580729 = newJObject()
  var query_580730 = newJObject()
  add(query_580730, "upload_protocol", newJString(uploadProtocol))
  add(query_580730, "fields", newJString(fields))
  add(query_580730, "quotaUser", newJString(quotaUser))
  add(path_580729, "name", newJString(name))
  add(query_580730, "alt", newJString(alt))
  add(query_580730, "oauth_token", newJString(oauthToken))
  add(query_580730, "callback", newJString(callback))
  add(query_580730, "access_token", newJString(accessToken))
  add(query_580730, "uploadType", newJString(uploadType))
  add(query_580730, "zone", newJString(zone))
  add(query_580730, "key", newJString(key))
  add(query_580730, "$.xgafv", newJString(Xgafv))
  add(query_580730, "projectId", newJString(projectId))
  add(query_580730, "prettyPrint", newJBool(prettyPrint))
  result = call_580728.call(path_580729, query_580730, nil, nil, nil)

var containerProjectsLocationsGetServerConfig* = Call_ContainerProjectsLocationsGetServerConfig_580710(
    name: "containerProjectsLocationsGetServerConfig", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{name}/serverConfig",
    validator: validate_ContainerProjectsLocationsGetServerConfig_580711,
    base: "/", url: url_ContainerProjectsLocationsGetServerConfig_580712,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsCancel_580731 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsOperationsCancel_580733(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsOperationsCancel_580732(path: JsonNode;
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
  var valid_580734 = path.getOrDefault("name")
  valid_580734 = validateParameter(valid_580734, JString, required = true,
                                 default = nil)
  if valid_580734 != nil:
    section.add "name", valid_580734
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
  var valid_580735 = query.getOrDefault("upload_protocol")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "upload_protocol", valid_580735
  var valid_580736 = query.getOrDefault("fields")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "fields", valid_580736
  var valid_580737 = query.getOrDefault("quotaUser")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "quotaUser", valid_580737
  var valid_580738 = query.getOrDefault("alt")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = newJString("json"))
  if valid_580738 != nil:
    section.add "alt", valid_580738
  var valid_580739 = query.getOrDefault("oauth_token")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "oauth_token", valid_580739
  var valid_580740 = query.getOrDefault("callback")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "callback", valid_580740
  var valid_580741 = query.getOrDefault("access_token")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "access_token", valid_580741
  var valid_580742 = query.getOrDefault("uploadType")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "uploadType", valid_580742
  var valid_580743 = query.getOrDefault("key")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = nil)
  if valid_580743 != nil:
    section.add "key", valid_580743
  var valid_580744 = query.getOrDefault("$.xgafv")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = newJString("1"))
  if valid_580744 != nil:
    section.add "$.xgafv", valid_580744
  var valid_580745 = query.getOrDefault("prettyPrint")
  valid_580745 = validateParameter(valid_580745, JBool, required = false,
                                 default = newJBool(true))
  if valid_580745 != nil:
    section.add "prettyPrint", valid_580745
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

proc call*(call_580747: Call_ContainerProjectsLocationsOperationsCancel_580731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the specified operation.
  ## 
  let valid = call_580747.validator(path, query, header, formData, body)
  let scheme = call_580747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580747.url(scheme.get, call_580747.host, call_580747.base,
                         call_580747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580747, url, valid)

proc call*(call_580748: Call_ContainerProjectsLocationsOperationsCancel_580731;
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
  var path_580749 = newJObject()
  var query_580750 = newJObject()
  var body_580751 = newJObject()
  add(query_580750, "upload_protocol", newJString(uploadProtocol))
  add(query_580750, "fields", newJString(fields))
  add(query_580750, "quotaUser", newJString(quotaUser))
  add(path_580749, "name", newJString(name))
  add(query_580750, "alt", newJString(alt))
  add(query_580750, "oauth_token", newJString(oauthToken))
  add(query_580750, "callback", newJString(callback))
  add(query_580750, "access_token", newJString(accessToken))
  add(query_580750, "uploadType", newJString(uploadType))
  add(query_580750, "key", newJString(key))
  add(query_580750, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580751 = body
  add(query_580750, "prettyPrint", newJBool(prettyPrint))
  result = call_580748.call(path_580749, query_580750, nil, nil, body_580751)

var containerProjectsLocationsOperationsCancel* = Call_ContainerProjectsLocationsOperationsCancel_580731(
    name: "containerProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ContainerProjectsLocationsOperationsCancel_580732,
    base: "/", url: url_ContainerProjectsLocationsOperationsCancel_580733,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCompleteIpRotation_580752 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersCompleteIpRotation_580754(
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

proc validate_ContainerProjectsLocationsClustersCompleteIpRotation_580753(
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
  var valid_580755 = path.getOrDefault("name")
  valid_580755 = validateParameter(valid_580755, JString, required = true,
                                 default = nil)
  if valid_580755 != nil:
    section.add "name", valid_580755
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
  var valid_580756 = query.getOrDefault("upload_protocol")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "upload_protocol", valid_580756
  var valid_580757 = query.getOrDefault("fields")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "fields", valid_580757
  var valid_580758 = query.getOrDefault("quotaUser")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "quotaUser", valid_580758
  var valid_580759 = query.getOrDefault("alt")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = newJString("json"))
  if valid_580759 != nil:
    section.add "alt", valid_580759
  var valid_580760 = query.getOrDefault("oauth_token")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "oauth_token", valid_580760
  var valid_580761 = query.getOrDefault("callback")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "callback", valid_580761
  var valid_580762 = query.getOrDefault("access_token")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "access_token", valid_580762
  var valid_580763 = query.getOrDefault("uploadType")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "uploadType", valid_580763
  var valid_580764 = query.getOrDefault("key")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "key", valid_580764
  var valid_580765 = query.getOrDefault("$.xgafv")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = newJString("1"))
  if valid_580765 != nil:
    section.add "$.xgafv", valid_580765
  var valid_580766 = query.getOrDefault("prettyPrint")
  valid_580766 = validateParameter(valid_580766, JBool, required = false,
                                 default = newJBool(true))
  if valid_580766 != nil:
    section.add "prettyPrint", valid_580766
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

proc call*(call_580768: Call_ContainerProjectsLocationsClustersCompleteIpRotation_580752;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes master IP rotation.
  ## 
  let valid = call_580768.validator(path, query, header, formData, body)
  let scheme = call_580768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580768.url(scheme.get, call_580768.host, call_580768.base,
                         call_580768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580768, url, valid)

proc call*(call_580769: Call_ContainerProjectsLocationsClustersCompleteIpRotation_580752;
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
  var path_580770 = newJObject()
  var query_580771 = newJObject()
  var body_580772 = newJObject()
  add(query_580771, "upload_protocol", newJString(uploadProtocol))
  add(query_580771, "fields", newJString(fields))
  add(query_580771, "quotaUser", newJString(quotaUser))
  add(path_580770, "name", newJString(name))
  add(query_580771, "alt", newJString(alt))
  add(query_580771, "oauth_token", newJString(oauthToken))
  add(query_580771, "callback", newJString(callback))
  add(query_580771, "access_token", newJString(accessToken))
  add(query_580771, "uploadType", newJString(uploadType))
  add(query_580771, "key", newJString(key))
  add(query_580771, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580772 = body
  add(query_580771, "prettyPrint", newJBool(prettyPrint))
  result = call_580769.call(path_580770, query_580771, nil, nil, body_580772)

var containerProjectsLocationsClustersCompleteIpRotation* = Call_ContainerProjectsLocationsClustersCompleteIpRotation_580752(
    name: "containerProjectsLocationsClustersCompleteIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:completeIpRotation",
    validator: validate_ContainerProjectsLocationsClustersCompleteIpRotation_580753,
    base: "/", url: url_ContainerProjectsLocationsClustersCompleteIpRotation_580754,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsRollback_580773 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsRollback_580775(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsRollback_580774(
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
  var valid_580776 = path.getOrDefault("name")
  valid_580776 = validateParameter(valid_580776, JString, required = true,
                                 default = nil)
  if valid_580776 != nil:
    section.add "name", valid_580776
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
  var valid_580777 = query.getOrDefault("upload_protocol")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "upload_protocol", valid_580777
  var valid_580778 = query.getOrDefault("fields")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "fields", valid_580778
  var valid_580779 = query.getOrDefault("quotaUser")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "quotaUser", valid_580779
  var valid_580780 = query.getOrDefault("alt")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = newJString("json"))
  if valid_580780 != nil:
    section.add "alt", valid_580780
  var valid_580781 = query.getOrDefault("oauth_token")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "oauth_token", valid_580781
  var valid_580782 = query.getOrDefault("callback")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "callback", valid_580782
  var valid_580783 = query.getOrDefault("access_token")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "access_token", valid_580783
  var valid_580784 = query.getOrDefault("uploadType")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "uploadType", valid_580784
  var valid_580785 = query.getOrDefault("key")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = nil)
  if valid_580785 != nil:
    section.add "key", valid_580785
  var valid_580786 = query.getOrDefault("$.xgafv")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = newJString("1"))
  if valid_580786 != nil:
    section.add "$.xgafv", valid_580786
  var valid_580787 = query.getOrDefault("prettyPrint")
  valid_580787 = validateParameter(valid_580787, JBool, required = false,
                                 default = newJBool(true))
  if valid_580787 != nil:
    section.add "prettyPrint", valid_580787
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

proc call*(call_580789: Call_ContainerProjectsLocationsClustersNodePoolsRollback_580773;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a previously Aborted or Failed NodePool upgrade.
  ## This makes no changes if the last upgrade successfully completed.
  ## 
  let valid = call_580789.validator(path, query, header, formData, body)
  let scheme = call_580789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580789.url(scheme.get, call_580789.host, call_580789.base,
                         call_580789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580789, url, valid)

proc call*(call_580790: Call_ContainerProjectsLocationsClustersNodePoolsRollback_580773;
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
  var path_580791 = newJObject()
  var query_580792 = newJObject()
  var body_580793 = newJObject()
  add(query_580792, "upload_protocol", newJString(uploadProtocol))
  add(query_580792, "fields", newJString(fields))
  add(query_580792, "quotaUser", newJString(quotaUser))
  add(path_580791, "name", newJString(name))
  add(query_580792, "alt", newJString(alt))
  add(query_580792, "oauth_token", newJString(oauthToken))
  add(query_580792, "callback", newJString(callback))
  add(query_580792, "access_token", newJString(accessToken))
  add(query_580792, "uploadType", newJString(uploadType))
  add(query_580792, "key", newJString(key))
  add(query_580792, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580793 = body
  add(query_580792, "prettyPrint", newJBool(prettyPrint))
  result = call_580790.call(path_580791, query_580792, nil, nil, body_580793)

var containerProjectsLocationsClustersNodePoolsRollback* = Call_ContainerProjectsLocationsClustersNodePoolsRollback_580773(
    name: "containerProjectsLocationsClustersNodePoolsRollback",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:rollback",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsRollback_580774,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsRollback_580775,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetAddons_580794 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetAddons_580796(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetAddons_580795(path: JsonNode;
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
  var valid_580797 = path.getOrDefault("name")
  valid_580797 = validateParameter(valid_580797, JString, required = true,
                                 default = nil)
  if valid_580797 != nil:
    section.add "name", valid_580797
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
  var valid_580798 = query.getOrDefault("upload_protocol")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = nil)
  if valid_580798 != nil:
    section.add "upload_protocol", valid_580798
  var valid_580799 = query.getOrDefault("fields")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "fields", valid_580799
  var valid_580800 = query.getOrDefault("quotaUser")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = nil)
  if valid_580800 != nil:
    section.add "quotaUser", valid_580800
  var valid_580801 = query.getOrDefault("alt")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = newJString("json"))
  if valid_580801 != nil:
    section.add "alt", valid_580801
  var valid_580802 = query.getOrDefault("oauth_token")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = nil)
  if valid_580802 != nil:
    section.add "oauth_token", valid_580802
  var valid_580803 = query.getOrDefault("callback")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "callback", valid_580803
  var valid_580804 = query.getOrDefault("access_token")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "access_token", valid_580804
  var valid_580805 = query.getOrDefault("uploadType")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = nil)
  if valid_580805 != nil:
    section.add "uploadType", valid_580805
  var valid_580806 = query.getOrDefault("key")
  valid_580806 = validateParameter(valid_580806, JString, required = false,
                                 default = nil)
  if valid_580806 != nil:
    section.add "key", valid_580806
  var valid_580807 = query.getOrDefault("$.xgafv")
  valid_580807 = validateParameter(valid_580807, JString, required = false,
                                 default = newJString("1"))
  if valid_580807 != nil:
    section.add "$.xgafv", valid_580807
  var valid_580808 = query.getOrDefault("prettyPrint")
  valid_580808 = validateParameter(valid_580808, JBool, required = false,
                                 default = newJBool(true))
  if valid_580808 != nil:
    section.add "prettyPrint", valid_580808
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

proc call*(call_580810: Call_ContainerProjectsLocationsClustersSetAddons_580794;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the addons for a specific cluster.
  ## 
  let valid = call_580810.validator(path, query, header, formData, body)
  let scheme = call_580810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580810.url(scheme.get, call_580810.host, call_580810.base,
                         call_580810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580810, url, valid)

proc call*(call_580811: Call_ContainerProjectsLocationsClustersSetAddons_580794;
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
  var path_580812 = newJObject()
  var query_580813 = newJObject()
  var body_580814 = newJObject()
  add(query_580813, "upload_protocol", newJString(uploadProtocol))
  add(query_580813, "fields", newJString(fields))
  add(query_580813, "quotaUser", newJString(quotaUser))
  add(path_580812, "name", newJString(name))
  add(query_580813, "alt", newJString(alt))
  add(query_580813, "oauth_token", newJString(oauthToken))
  add(query_580813, "callback", newJString(callback))
  add(query_580813, "access_token", newJString(accessToken))
  add(query_580813, "uploadType", newJString(uploadType))
  add(query_580813, "key", newJString(key))
  add(query_580813, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580814 = body
  add(query_580813, "prettyPrint", newJBool(prettyPrint))
  result = call_580811.call(path_580812, query_580813, nil, nil, body_580814)

var containerProjectsLocationsClustersSetAddons* = Call_ContainerProjectsLocationsClustersSetAddons_580794(
    name: "containerProjectsLocationsClustersSetAddons",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAddons",
    validator: validate_ContainerProjectsLocationsClustersSetAddons_580795,
    base: "/", url: url_ContainerProjectsLocationsClustersSetAddons_580796,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580815 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580817(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580816(
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
  var valid_580818 = path.getOrDefault("name")
  valid_580818 = validateParameter(valid_580818, JString, required = true,
                                 default = nil)
  if valid_580818 != nil:
    section.add "name", valid_580818
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
  var valid_580819 = query.getOrDefault("upload_protocol")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "upload_protocol", valid_580819
  var valid_580820 = query.getOrDefault("fields")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "fields", valid_580820
  var valid_580821 = query.getOrDefault("quotaUser")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = nil)
  if valid_580821 != nil:
    section.add "quotaUser", valid_580821
  var valid_580822 = query.getOrDefault("alt")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = newJString("json"))
  if valid_580822 != nil:
    section.add "alt", valid_580822
  var valid_580823 = query.getOrDefault("oauth_token")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "oauth_token", valid_580823
  var valid_580824 = query.getOrDefault("callback")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = nil)
  if valid_580824 != nil:
    section.add "callback", valid_580824
  var valid_580825 = query.getOrDefault("access_token")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "access_token", valid_580825
  var valid_580826 = query.getOrDefault("uploadType")
  valid_580826 = validateParameter(valid_580826, JString, required = false,
                                 default = nil)
  if valid_580826 != nil:
    section.add "uploadType", valid_580826
  var valid_580827 = query.getOrDefault("key")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "key", valid_580827
  var valid_580828 = query.getOrDefault("$.xgafv")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = newJString("1"))
  if valid_580828 != nil:
    section.add "$.xgafv", valid_580828
  var valid_580829 = query.getOrDefault("prettyPrint")
  valid_580829 = validateParameter(valid_580829, JBool, required = false,
                                 default = newJBool(true))
  if valid_580829 != nil:
    section.add "prettyPrint", valid_580829
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

proc call*(call_580831: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580815;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the autoscaling settings for the specified node pool.
  ## 
  let valid = call_580831.validator(path, query, header, formData, body)
  let scheme = call_580831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580831.url(scheme.get, call_580831.host, call_580831.base,
                         call_580831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580831, url, valid)

proc call*(call_580832: Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580815;
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
  var path_580833 = newJObject()
  var query_580834 = newJObject()
  var body_580835 = newJObject()
  add(query_580834, "upload_protocol", newJString(uploadProtocol))
  add(query_580834, "fields", newJString(fields))
  add(query_580834, "quotaUser", newJString(quotaUser))
  add(path_580833, "name", newJString(name))
  add(query_580834, "alt", newJString(alt))
  add(query_580834, "oauth_token", newJString(oauthToken))
  add(query_580834, "callback", newJString(callback))
  add(query_580834, "access_token", newJString(accessToken))
  add(query_580834, "uploadType", newJString(uploadType))
  add(query_580834, "key", newJString(key))
  add(query_580834, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580835 = body
  add(query_580834, "prettyPrint", newJBool(prettyPrint))
  result = call_580832.call(path_580833, query_580834, nil, nil, body_580835)

var containerProjectsLocationsClustersNodePoolsSetAutoscaling* = Call_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580815(
    name: "containerProjectsLocationsClustersNodePoolsSetAutoscaling",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setAutoscaling", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580816,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetAutoscaling_580817,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLegacyAbac_580836 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetLegacyAbac_580838(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetLegacyAbac_580837(
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
  var valid_580839 = path.getOrDefault("name")
  valid_580839 = validateParameter(valid_580839, JString, required = true,
                                 default = nil)
  if valid_580839 != nil:
    section.add "name", valid_580839
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
  var valid_580840 = query.getOrDefault("upload_protocol")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = nil)
  if valid_580840 != nil:
    section.add "upload_protocol", valid_580840
  var valid_580841 = query.getOrDefault("fields")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "fields", valid_580841
  var valid_580842 = query.getOrDefault("quotaUser")
  valid_580842 = validateParameter(valid_580842, JString, required = false,
                                 default = nil)
  if valid_580842 != nil:
    section.add "quotaUser", valid_580842
  var valid_580843 = query.getOrDefault("alt")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = newJString("json"))
  if valid_580843 != nil:
    section.add "alt", valid_580843
  var valid_580844 = query.getOrDefault("oauth_token")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "oauth_token", valid_580844
  var valid_580845 = query.getOrDefault("callback")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "callback", valid_580845
  var valid_580846 = query.getOrDefault("access_token")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = nil)
  if valid_580846 != nil:
    section.add "access_token", valid_580846
  var valid_580847 = query.getOrDefault("uploadType")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "uploadType", valid_580847
  var valid_580848 = query.getOrDefault("key")
  valid_580848 = validateParameter(valid_580848, JString, required = false,
                                 default = nil)
  if valid_580848 != nil:
    section.add "key", valid_580848
  var valid_580849 = query.getOrDefault("$.xgafv")
  valid_580849 = validateParameter(valid_580849, JString, required = false,
                                 default = newJString("1"))
  if valid_580849 != nil:
    section.add "$.xgafv", valid_580849
  var valid_580850 = query.getOrDefault("prettyPrint")
  valid_580850 = validateParameter(valid_580850, JBool, required = false,
                                 default = newJBool(true))
  if valid_580850 != nil:
    section.add "prettyPrint", valid_580850
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

proc call*(call_580852: Call_ContainerProjectsLocationsClustersSetLegacyAbac_580836;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables the ABAC authorization mechanism on a cluster.
  ## 
  let valid = call_580852.validator(path, query, header, formData, body)
  let scheme = call_580852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580852.url(scheme.get, call_580852.host, call_580852.base,
                         call_580852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580852, url, valid)

proc call*(call_580853: Call_ContainerProjectsLocationsClustersSetLegacyAbac_580836;
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
  var path_580854 = newJObject()
  var query_580855 = newJObject()
  var body_580856 = newJObject()
  add(query_580855, "upload_protocol", newJString(uploadProtocol))
  add(query_580855, "fields", newJString(fields))
  add(query_580855, "quotaUser", newJString(quotaUser))
  add(path_580854, "name", newJString(name))
  add(query_580855, "alt", newJString(alt))
  add(query_580855, "oauth_token", newJString(oauthToken))
  add(query_580855, "callback", newJString(callback))
  add(query_580855, "access_token", newJString(accessToken))
  add(query_580855, "uploadType", newJString(uploadType))
  add(query_580855, "key", newJString(key))
  add(query_580855, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580856 = body
  add(query_580855, "prettyPrint", newJBool(prettyPrint))
  result = call_580853.call(path_580854, query_580855, nil, nil, body_580856)

var containerProjectsLocationsClustersSetLegacyAbac* = Call_ContainerProjectsLocationsClustersSetLegacyAbac_580836(
    name: "containerProjectsLocationsClustersSetLegacyAbac",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLegacyAbac",
    validator: validate_ContainerProjectsLocationsClustersSetLegacyAbac_580837,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLegacyAbac_580838,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLocations_580857 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetLocations_580859(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetLocations_580858(
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
  var valid_580860 = path.getOrDefault("name")
  valid_580860 = validateParameter(valid_580860, JString, required = true,
                                 default = nil)
  if valid_580860 != nil:
    section.add "name", valid_580860
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
  var valid_580861 = query.getOrDefault("upload_protocol")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "upload_protocol", valid_580861
  var valid_580862 = query.getOrDefault("fields")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = nil)
  if valid_580862 != nil:
    section.add "fields", valid_580862
  var valid_580863 = query.getOrDefault("quotaUser")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "quotaUser", valid_580863
  var valid_580864 = query.getOrDefault("alt")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = newJString("json"))
  if valid_580864 != nil:
    section.add "alt", valid_580864
  var valid_580865 = query.getOrDefault("oauth_token")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "oauth_token", valid_580865
  var valid_580866 = query.getOrDefault("callback")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "callback", valid_580866
  var valid_580867 = query.getOrDefault("access_token")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = nil)
  if valid_580867 != nil:
    section.add "access_token", valid_580867
  var valid_580868 = query.getOrDefault("uploadType")
  valid_580868 = validateParameter(valid_580868, JString, required = false,
                                 default = nil)
  if valid_580868 != nil:
    section.add "uploadType", valid_580868
  var valid_580869 = query.getOrDefault("key")
  valid_580869 = validateParameter(valid_580869, JString, required = false,
                                 default = nil)
  if valid_580869 != nil:
    section.add "key", valid_580869
  var valid_580870 = query.getOrDefault("$.xgafv")
  valid_580870 = validateParameter(valid_580870, JString, required = false,
                                 default = newJString("1"))
  if valid_580870 != nil:
    section.add "$.xgafv", valid_580870
  var valid_580871 = query.getOrDefault("prettyPrint")
  valid_580871 = validateParameter(valid_580871, JBool, required = false,
                                 default = newJBool(true))
  if valid_580871 != nil:
    section.add "prettyPrint", valid_580871
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

proc call*(call_580873: Call_ContainerProjectsLocationsClustersSetLocations_580857;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the locations for a specific cluster.
  ## 
  let valid = call_580873.validator(path, query, header, formData, body)
  let scheme = call_580873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580873.url(scheme.get, call_580873.host, call_580873.base,
                         call_580873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580873, url, valid)

proc call*(call_580874: Call_ContainerProjectsLocationsClustersSetLocations_580857;
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
  var path_580875 = newJObject()
  var query_580876 = newJObject()
  var body_580877 = newJObject()
  add(query_580876, "upload_protocol", newJString(uploadProtocol))
  add(query_580876, "fields", newJString(fields))
  add(query_580876, "quotaUser", newJString(quotaUser))
  add(path_580875, "name", newJString(name))
  add(query_580876, "alt", newJString(alt))
  add(query_580876, "oauth_token", newJString(oauthToken))
  add(query_580876, "callback", newJString(callback))
  add(query_580876, "access_token", newJString(accessToken))
  add(query_580876, "uploadType", newJString(uploadType))
  add(query_580876, "key", newJString(key))
  add(query_580876, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580877 = body
  add(query_580876, "prettyPrint", newJBool(prettyPrint))
  result = call_580874.call(path_580875, query_580876, nil, nil, body_580877)

var containerProjectsLocationsClustersSetLocations* = Call_ContainerProjectsLocationsClustersSetLocations_580857(
    name: "containerProjectsLocationsClustersSetLocations",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLocations",
    validator: validate_ContainerProjectsLocationsClustersSetLocations_580858,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLocations_580859,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetLogging_580878 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetLogging_580880(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetLogging_580879(path: JsonNode;
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
  var valid_580881 = path.getOrDefault("name")
  valid_580881 = validateParameter(valid_580881, JString, required = true,
                                 default = nil)
  if valid_580881 != nil:
    section.add "name", valid_580881
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
  var valid_580882 = query.getOrDefault("upload_protocol")
  valid_580882 = validateParameter(valid_580882, JString, required = false,
                                 default = nil)
  if valid_580882 != nil:
    section.add "upload_protocol", valid_580882
  var valid_580883 = query.getOrDefault("fields")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "fields", valid_580883
  var valid_580884 = query.getOrDefault("quotaUser")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = nil)
  if valid_580884 != nil:
    section.add "quotaUser", valid_580884
  var valid_580885 = query.getOrDefault("alt")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = newJString("json"))
  if valid_580885 != nil:
    section.add "alt", valid_580885
  var valid_580886 = query.getOrDefault("oauth_token")
  valid_580886 = validateParameter(valid_580886, JString, required = false,
                                 default = nil)
  if valid_580886 != nil:
    section.add "oauth_token", valid_580886
  var valid_580887 = query.getOrDefault("callback")
  valid_580887 = validateParameter(valid_580887, JString, required = false,
                                 default = nil)
  if valid_580887 != nil:
    section.add "callback", valid_580887
  var valid_580888 = query.getOrDefault("access_token")
  valid_580888 = validateParameter(valid_580888, JString, required = false,
                                 default = nil)
  if valid_580888 != nil:
    section.add "access_token", valid_580888
  var valid_580889 = query.getOrDefault("uploadType")
  valid_580889 = validateParameter(valid_580889, JString, required = false,
                                 default = nil)
  if valid_580889 != nil:
    section.add "uploadType", valid_580889
  var valid_580890 = query.getOrDefault("key")
  valid_580890 = validateParameter(valid_580890, JString, required = false,
                                 default = nil)
  if valid_580890 != nil:
    section.add "key", valid_580890
  var valid_580891 = query.getOrDefault("$.xgafv")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = newJString("1"))
  if valid_580891 != nil:
    section.add "$.xgafv", valid_580891
  var valid_580892 = query.getOrDefault("prettyPrint")
  valid_580892 = validateParameter(valid_580892, JBool, required = false,
                                 default = newJBool(true))
  if valid_580892 != nil:
    section.add "prettyPrint", valid_580892
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

proc call*(call_580894: Call_ContainerProjectsLocationsClustersSetLogging_580878;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the logging service for a specific cluster.
  ## 
  let valid = call_580894.validator(path, query, header, formData, body)
  let scheme = call_580894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580894.url(scheme.get, call_580894.host, call_580894.base,
                         call_580894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580894, url, valid)

proc call*(call_580895: Call_ContainerProjectsLocationsClustersSetLogging_580878;
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
  var path_580896 = newJObject()
  var query_580897 = newJObject()
  var body_580898 = newJObject()
  add(query_580897, "upload_protocol", newJString(uploadProtocol))
  add(query_580897, "fields", newJString(fields))
  add(query_580897, "quotaUser", newJString(quotaUser))
  add(path_580896, "name", newJString(name))
  add(query_580897, "alt", newJString(alt))
  add(query_580897, "oauth_token", newJString(oauthToken))
  add(query_580897, "callback", newJString(callback))
  add(query_580897, "access_token", newJString(accessToken))
  add(query_580897, "uploadType", newJString(uploadType))
  add(query_580897, "key", newJString(key))
  add(query_580897, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580898 = body
  add(query_580897, "prettyPrint", newJBool(prettyPrint))
  result = call_580895.call(path_580896, query_580897, nil, nil, body_580898)

var containerProjectsLocationsClustersSetLogging* = Call_ContainerProjectsLocationsClustersSetLogging_580878(
    name: "containerProjectsLocationsClustersSetLogging",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setLogging",
    validator: validate_ContainerProjectsLocationsClustersSetLogging_580879,
    base: "/", url: url_ContainerProjectsLocationsClustersSetLogging_580880,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580899 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetMaintenancePolicy_580901(
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

proc validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_580900(
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
  var valid_580902 = path.getOrDefault("name")
  valid_580902 = validateParameter(valid_580902, JString, required = true,
                                 default = nil)
  if valid_580902 != nil:
    section.add "name", valid_580902
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
  var valid_580903 = query.getOrDefault("upload_protocol")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = nil)
  if valid_580903 != nil:
    section.add "upload_protocol", valid_580903
  var valid_580904 = query.getOrDefault("fields")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "fields", valid_580904
  var valid_580905 = query.getOrDefault("quotaUser")
  valid_580905 = validateParameter(valid_580905, JString, required = false,
                                 default = nil)
  if valid_580905 != nil:
    section.add "quotaUser", valid_580905
  var valid_580906 = query.getOrDefault("alt")
  valid_580906 = validateParameter(valid_580906, JString, required = false,
                                 default = newJString("json"))
  if valid_580906 != nil:
    section.add "alt", valid_580906
  var valid_580907 = query.getOrDefault("oauth_token")
  valid_580907 = validateParameter(valid_580907, JString, required = false,
                                 default = nil)
  if valid_580907 != nil:
    section.add "oauth_token", valid_580907
  var valid_580908 = query.getOrDefault("callback")
  valid_580908 = validateParameter(valid_580908, JString, required = false,
                                 default = nil)
  if valid_580908 != nil:
    section.add "callback", valid_580908
  var valid_580909 = query.getOrDefault("access_token")
  valid_580909 = validateParameter(valid_580909, JString, required = false,
                                 default = nil)
  if valid_580909 != nil:
    section.add "access_token", valid_580909
  var valid_580910 = query.getOrDefault("uploadType")
  valid_580910 = validateParameter(valid_580910, JString, required = false,
                                 default = nil)
  if valid_580910 != nil:
    section.add "uploadType", valid_580910
  var valid_580911 = query.getOrDefault("key")
  valid_580911 = validateParameter(valid_580911, JString, required = false,
                                 default = nil)
  if valid_580911 != nil:
    section.add "key", valid_580911
  var valid_580912 = query.getOrDefault("$.xgafv")
  valid_580912 = validateParameter(valid_580912, JString, required = false,
                                 default = newJString("1"))
  if valid_580912 != nil:
    section.add "$.xgafv", valid_580912
  var valid_580913 = query.getOrDefault("prettyPrint")
  valid_580913 = validateParameter(valid_580913, JBool, required = false,
                                 default = newJBool(true))
  if valid_580913 != nil:
    section.add "prettyPrint", valid_580913
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

proc call*(call_580915: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580899;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the maintenance policy for a cluster.
  ## 
  let valid = call_580915.validator(path, query, header, formData, body)
  let scheme = call_580915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580915.url(scheme.get, call_580915.host, call_580915.base,
                         call_580915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580915, url, valid)

proc call*(call_580916: Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580899;
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
  var path_580917 = newJObject()
  var query_580918 = newJObject()
  var body_580919 = newJObject()
  add(query_580918, "upload_protocol", newJString(uploadProtocol))
  add(query_580918, "fields", newJString(fields))
  add(query_580918, "quotaUser", newJString(quotaUser))
  add(path_580917, "name", newJString(name))
  add(query_580918, "alt", newJString(alt))
  add(query_580918, "oauth_token", newJString(oauthToken))
  add(query_580918, "callback", newJString(callback))
  add(query_580918, "access_token", newJString(accessToken))
  add(query_580918, "uploadType", newJString(uploadType))
  add(query_580918, "key", newJString(key))
  add(query_580918, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580919 = body
  add(query_580918, "prettyPrint", newJBool(prettyPrint))
  result = call_580916.call(path_580917, query_580918, nil, nil, body_580919)

var containerProjectsLocationsClustersSetMaintenancePolicy* = Call_ContainerProjectsLocationsClustersSetMaintenancePolicy_580899(
    name: "containerProjectsLocationsClustersSetMaintenancePolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMaintenancePolicy",
    validator: validate_ContainerProjectsLocationsClustersSetMaintenancePolicy_580900,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMaintenancePolicy_580901,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580920 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsSetManagement_580922(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_580921(
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
  var valid_580923 = path.getOrDefault("name")
  valid_580923 = validateParameter(valid_580923, JString, required = true,
                                 default = nil)
  if valid_580923 != nil:
    section.add "name", valid_580923
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
  var valid_580924 = query.getOrDefault("upload_protocol")
  valid_580924 = validateParameter(valid_580924, JString, required = false,
                                 default = nil)
  if valid_580924 != nil:
    section.add "upload_protocol", valid_580924
  var valid_580925 = query.getOrDefault("fields")
  valid_580925 = validateParameter(valid_580925, JString, required = false,
                                 default = nil)
  if valid_580925 != nil:
    section.add "fields", valid_580925
  var valid_580926 = query.getOrDefault("quotaUser")
  valid_580926 = validateParameter(valid_580926, JString, required = false,
                                 default = nil)
  if valid_580926 != nil:
    section.add "quotaUser", valid_580926
  var valid_580927 = query.getOrDefault("alt")
  valid_580927 = validateParameter(valid_580927, JString, required = false,
                                 default = newJString("json"))
  if valid_580927 != nil:
    section.add "alt", valid_580927
  var valid_580928 = query.getOrDefault("oauth_token")
  valid_580928 = validateParameter(valid_580928, JString, required = false,
                                 default = nil)
  if valid_580928 != nil:
    section.add "oauth_token", valid_580928
  var valid_580929 = query.getOrDefault("callback")
  valid_580929 = validateParameter(valid_580929, JString, required = false,
                                 default = nil)
  if valid_580929 != nil:
    section.add "callback", valid_580929
  var valid_580930 = query.getOrDefault("access_token")
  valid_580930 = validateParameter(valid_580930, JString, required = false,
                                 default = nil)
  if valid_580930 != nil:
    section.add "access_token", valid_580930
  var valid_580931 = query.getOrDefault("uploadType")
  valid_580931 = validateParameter(valid_580931, JString, required = false,
                                 default = nil)
  if valid_580931 != nil:
    section.add "uploadType", valid_580931
  var valid_580932 = query.getOrDefault("key")
  valid_580932 = validateParameter(valid_580932, JString, required = false,
                                 default = nil)
  if valid_580932 != nil:
    section.add "key", valid_580932
  var valid_580933 = query.getOrDefault("$.xgafv")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = newJString("1"))
  if valid_580933 != nil:
    section.add "$.xgafv", valid_580933
  var valid_580934 = query.getOrDefault("prettyPrint")
  valid_580934 = validateParameter(valid_580934, JBool, required = false,
                                 default = newJBool(true))
  if valid_580934 != nil:
    section.add "prettyPrint", valid_580934
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

proc call*(call_580936: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580920;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the NodeManagement options for a node pool.
  ## 
  let valid = call_580936.validator(path, query, header, formData, body)
  let scheme = call_580936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580936.url(scheme.get, call_580936.host, call_580936.base,
                         call_580936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580936, url, valid)

proc call*(call_580937: Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580920;
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
  var path_580938 = newJObject()
  var query_580939 = newJObject()
  var body_580940 = newJObject()
  add(query_580939, "upload_protocol", newJString(uploadProtocol))
  add(query_580939, "fields", newJString(fields))
  add(query_580939, "quotaUser", newJString(quotaUser))
  add(path_580938, "name", newJString(name))
  add(query_580939, "alt", newJString(alt))
  add(query_580939, "oauth_token", newJString(oauthToken))
  add(query_580939, "callback", newJString(callback))
  add(query_580939, "access_token", newJString(accessToken))
  add(query_580939, "uploadType", newJString(uploadType))
  add(query_580939, "key", newJString(key))
  add(query_580939, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580940 = body
  add(query_580939, "prettyPrint", newJBool(prettyPrint))
  result = call_580937.call(path_580938, query_580939, nil, nil, body_580940)

var containerProjectsLocationsClustersNodePoolsSetManagement* = Call_ContainerProjectsLocationsClustersNodePoolsSetManagement_580920(
    name: "containerProjectsLocationsClustersNodePoolsSetManagement",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setManagement", validator: validate_ContainerProjectsLocationsClustersNodePoolsSetManagement_580921,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetManagement_580922,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMasterAuth_580941 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetMasterAuth_580943(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetMasterAuth_580942(
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
  var valid_580944 = path.getOrDefault("name")
  valid_580944 = validateParameter(valid_580944, JString, required = true,
                                 default = nil)
  if valid_580944 != nil:
    section.add "name", valid_580944
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
  var valid_580945 = query.getOrDefault("upload_protocol")
  valid_580945 = validateParameter(valid_580945, JString, required = false,
                                 default = nil)
  if valid_580945 != nil:
    section.add "upload_protocol", valid_580945
  var valid_580946 = query.getOrDefault("fields")
  valid_580946 = validateParameter(valid_580946, JString, required = false,
                                 default = nil)
  if valid_580946 != nil:
    section.add "fields", valid_580946
  var valid_580947 = query.getOrDefault("quotaUser")
  valid_580947 = validateParameter(valid_580947, JString, required = false,
                                 default = nil)
  if valid_580947 != nil:
    section.add "quotaUser", valid_580947
  var valid_580948 = query.getOrDefault("alt")
  valid_580948 = validateParameter(valid_580948, JString, required = false,
                                 default = newJString("json"))
  if valid_580948 != nil:
    section.add "alt", valid_580948
  var valid_580949 = query.getOrDefault("oauth_token")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = nil)
  if valid_580949 != nil:
    section.add "oauth_token", valid_580949
  var valid_580950 = query.getOrDefault("callback")
  valid_580950 = validateParameter(valid_580950, JString, required = false,
                                 default = nil)
  if valid_580950 != nil:
    section.add "callback", valid_580950
  var valid_580951 = query.getOrDefault("access_token")
  valid_580951 = validateParameter(valid_580951, JString, required = false,
                                 default = nil)
  if valid_580951 != nil:
    section.add "access_token", valid_580951
  var valid_580952 = query.getOrDefault("uploadType")
  valid_580952 = validateParameter(valid_580952, JString, required = false,
                                 default = nil)
  if valid_580952 != nil:
    section.add "uploadType", valid_580952
  var valid_580953 = query.getOrDefault("key")
  valid_580953 = validateParameter(valid_580953, JString, required = false,
                                 default = nil)
  if valid_580953 != nil:
    section.add "key", valid_580953
  var valid_580954 = query.getOrDefault("$.xgafv")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = newJString("1"))
  if valid_580954 != nil:
    section.add "$.xgafv", valid_580954
  var valid_580955 = query.getOrDefault("prettyPrint")
  valid_580955 = validateParameter(valid_580955, JBool, required = false,
                                 default = newJBool(true))
  if valid_580955 != nil:
    section.add "prettyPrint", valid_580955
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

proc call*(call_580957: Call_ContainerProjectsLocationsClustersSetMasterAuth_580941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets master auth materials. Currently supports changing the admin password
  ## or a specific cluster, either via password generation or explicitly setting
  ## the password.
  ## 
  let valid = call_580957.validator(path, query, header, formData, body)
  let scheme = call_580957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580957.url(scheme.get, call_580957.host, call_580957.base,
                         call_580957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580957, url, valid)

proc call*(call_580958: Call_ContainerProjectsLocationsClustersSetMasterAuth_580941;
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
  var path_580959 = newJObject()
  var query_580960 = newJObject()
  var body_580961 = newJObject()
  add(query_580960, "upload_protocol", newJString(uploadProtocol))
  add(query_580960, "fields", newJString(fields))
  add(query_580960, "quotaUser", newJString(quotaUser))
  add(path_580959, "name", newJString(name))
  add(query_580960, "alt", newJString(alt))
  add(query_580960, "oauth_token", newJString(oauthToken))
  add(query_580960, "callback", newJString(callback))
  add(query_580960, "access_token", newJString(accessToken))
  add(query_580960, "uploadType", newJString(uploadType))
  add(query_580960, "key", newJString(key))
  add(query_580960, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580961 = body
  add(query_580960, "prettyPrint", newJBool(prettyPrint))
  result = call_580958.call(path_580959, query_580960, nil, nil, body_580961)

var containerProjectsLocationsClustersSetMasterAuth* = Call_ContainerProjectsLocationsClustersSetMasterAuth_580941(
    name: "containerProjectsLocationsClustersSetMasterAuth",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMasterAuth",
    validator: validate_ContainerProjectsLocationsClustersSetMasterAuth_580942,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMasterAuth_580943,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetMonitoring_580962 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetMonitoring_580964(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersSetMonitoring_580963(
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
  var valid_580965 = path.getOrDefault("name")
  valid_580965 = validateParameter(valid_580965, JString, required = true,
                                 default = nil)
  if valid_580965 != nil:
    section.add "name", valid_580965
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
  var valid_580966 = query.getOrDefault("upload_protocol")
  valid_580966 = validateParameter(valid_580966, JString, required = false,
                                 default = nil)
  if valid_580966 != nil:
    section.add "upload_protocol", valid_580966
  var valid_580967 = query.getOrDefault("fields")
  valid_580967 = validateParameter(valid_580967, JString, required = false,
                                 default = nil)
  if valid_580967 != nil:
    section.add "fields", valid_580967
  var valid_580968 = query.getOrDefault("quotaUser")
  valid_580968 = validateParameter(valid_580968, JString, required = false,
                                 default = nil)
  if valid_580968 != nil:
    section.add "quotaUser", valid_580968
  var valid_580969 = query.getOrDefault("alt")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = newJString("json"))
  if valid_580969 != nil:
    section.add "alt", valid_580969
  var valid_580970 = query.getOrDefault("oauth_token")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "oauth_token", valid_580970
  var valid_580971 = query.getOrDefault("callback")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = nil)
  if valid_580971 != nil:
    section.add "callback", valid_580971
  var valid_580972 = query.getOrDefault("access_token")
  valid_580972 = validateParameter(valid_580972, JString, required = false,
                                 default = nil)
  if valid_580972 != nil:
    section.add "access_token", valid_580972
  var valid_580973 = query.getOrDefault("uploadType")
  valid_580973 = validateParameter(valid_580973, JString, required = false,
                                 default = nil)
  if valid_580973 != nil:
    section.add "uploadType", valid_580973
  var valid_580974 = query.getOrDefault("key")
  valid_580974 = validateParameter(valid_580974, JString, required = false,
                                 default = nil)
  if valid_580974 != nil:
    section.add "key", valid_580974
  var valid_580975 = query.getOrDefault("$.xgafv")
  valid_580975 = validateParameter(valid_580975, JString, required = false,
                                 default = newJString("1"))
  if valid_580975 != nil:
    section.add "$.xgafv", valid_580975
  var valid_580976 = query.getOrDefault("prettyPrint")
  valid_580976 = validateParameter(valid_580976, JBool, required = false,
                                 default = newJBool(true))
  if valid_580976 != nil:
    section.add "prettyPrint", valid_580976
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

proc call*(call_580978: Call_ContainerProjectsLocationsClustersSetMonitoring_580962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the monitoring service for a specific cluster.
  ## 
  let valid = call_580978.validator(path, query, header, formData, body)
  let scheme = call_580978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580978.url(scheme.get, call_580978.host, call_580978.base,
                         call_580978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580978, url, valid)

proc call*(call_580979: Call_ContainerProjectsLocationsClustersSetMonitoring_580962;
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
  var path_580980 = newJObject()
  var query_580981 = newJObject()
  var body_580982 = newJObject()
  add(query_580981, "upload_protocol", newJString(uploadProtocol))
  add(query_580981, "fields", newJString(fields))
  add(query_580981, "quotaUser", newJString(quotaUser))
  add(path_580980, "name", newJString(name))
  add(query_580981, "alt", newJString(alt))
  add(query_580981, "oauth_token", newJString(oauthToken))
  add(query_580981, "callback", newJString(callback))
  add(query_580981, "access_token", newJString(accessToken))
  add(query_580981, "uploadType", newJString(uploadType))
  add(query_580981, "key", newJString(key))
  add(query_580981, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580982 = body
  add(query_580981, "prettyPrint", newJBool(prettyPrint))
  result = call_580979.call(path_580980, query_580981, nil, nil, body_580982)

var containerProjectsLocationsClustersSetMonitoring* = Call_ContainerProjectsLocationsClustersSetMonitoring_580962(
    name: "containerProjectsLocationsClustersSetMonitoring",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setMonitoring",
    validator: validate_ContainerProjectsLocationsClustersSetMonitoring_580963,
    base: "/", url: url_ContainerProjectsLocationsClustersSetMonitoring_580964,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetNetworkPolicy_580983 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetNetworkPolicy_580985(
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

proc validate_ContainerProjectsLocationsClustersSetNetworkPolicy_580984(
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
  var valid_580986 = path.getOrDefault("name")
  valid_580986 = validateParameter(valid_580986, JString, required = true,
                                 default = nil)
  if valid_580986 != nil:
    section.add "name", valid_580986
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
  var valid_580987 = query.getOrDefault("upload_protocol")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = nil)
  if valid_580987 != nil:
    section.add "upload_protocol", valid_580987
  var valid_580988 = query.getOrDefault("fields")
  valid_580988 = validateParameter(valid_580988, JString, required = false,
                                 default = nil)
  if valid_580988 != nil:
    section.add "fields", valid_580988
  var valid_580989 = query.getOrDefault("quotaUser")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "quotaUser", valid_580989
  var valid_580990 = query.getOrDefault("alt")
  valid_580990 = validateParameter(valid_580990, JString, required = false,
                                 default = newJString("json"))
  if valid_580990 != nil:
    section.add "alt", valid_580990
  var valid_580991 = query.getOrDefault("oauth_token")
  valid_580991 = validateParameter(valid_580991, JString, required = false,
                                 default = nil)
  if valid_580991 != nil:
    section.add "oauth_token", valid_580991
  var valid_580992 = query.getOrDefault("callback")
  valid_580992 = validateParameter(valid_580992, JString, required = false,
                                 default = nil)
  if valid_580992 != nil:
    section.add "callback", valid_580992
  var valid_580993 = query.getOrDefault("access_token")
  valid_580993 = validateParameter(valid_580993, JString, required = false,
                                 default = nil)
  if valid_580993 != nil:
    section.add "access_token", valid_580993
  var valid_580994 = query.getOrDefault("uploadType")
  valid_580994 = validateParameter(valid_580994, JString, required = false,
                                 default = nil)
  if valid_580994 != nil:
    section.add "uploadType", valid_580994
  var valid_580995 = query.getOrDefault("key")
  valid_580995 = validateParameter(valid_580995, JString, required = false,
                                 default = nil)
  if valid_580995 != nil:
    section.add "key", valid_580995
  var valid_580996 = query.getOrDefault("$.xgafv")
  valid_580996 = validateParameter(valid_580996, JString, required = false,
                                 default = newJString("1"))
  if valid_580996 != nil:
    section.add "$.xgafv", valid_580996
  var valid_580997 = query.getOrDefault("prettyPrint")
  valid_580997 = validateParameter(valid_580997, JBool, required = false,
                                 default = newJBool(true))
  if valid_580997 != nil:
    section.add "prettyPrint", valid_580997
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

proc call*(call_580999: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_580983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables or disables Network Policy for a cluster.
  ## 
  let valid = call_580999.validator(path, query, header, formData, body)
  let scheme = call_580999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580999.url(scheme.get, call_580999.host, call_580999.base,
                         call_580999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580999, url, valid)

proc call*(call_581000: Call_ContainerProjectsLocationsClustersSetNetworkPolicy_580983;
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
  var path_581001 = newJObject()
  var query_581002 = newJObject()
  var body_581003 = newJObject()
  add(query_581002, "upload_protocol", newJString(uploadProtocol))
  add(query_581002, "fields", newJString(fields))
  add(query_581002, "quotaUser", newJString(quotaUser))
  add(path_581001, "name", newJString(name))
  add(query_581002, "alt", newJString(alt))
  add(query_581002, "oauth_token", newJString(oauthToken))
  add(query_581002, "callback", newJString(callback))
  add(query_581002, "access_token", newJString(accessToken))
  add(query_581002, "uploadType", newJString(uploadType))
  add(query_581002, "key", newJString(key))
  add(query_581002, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581003 = body
  add(query_581002, "prettyPrint", newJBool(prettyPrint))
  result = call_581000.call(path_581001, query_581002, nil, nil, body_581003)

var containerProjectsLocationsClustersSetNetworkPolicy* = Call_ContainerProjectsLocationsClustersSetNetworkPolicy_580983(
    name: "containerProjectsLocationsClustersSetNetworkPolicy",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setNetworkPolicy",
    validator: validate_ContainerProjectsLocationsClustersSetNetworkPolicy_580984,
    base: "/", url: url_ContainerProjectsLocationsClustersSetNetworkPolicy_580985,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersSetResourceLabels_581004 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersSetResourceLabels_581006(
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

proc validate_ContainerProjectsLocationsClustersSetResourceLabels_581005(
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
  var valid_581007 = path.getOrDefault("name")
  valid_581007 = validateParameter(valid_581007, JString, required = true,
                                 default = nil)
  if valid_581007 != nil:
    section.add "name", valid_581007
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
  var valid_581008 = query.getOrDefault("upload_protocol")
  valid_581008 = validateParameter(valid_581008, JString, required = false,
                                 default = nil)
  if valid_581008 != nil:
    section.add "upload_protocol", valid_581008
  var valid_581009 = query.getOrDefault("fields")
  valid_581009 = validateParameter(valid_581009, JString, required = false,
                                 default = nil)
  if valid_581009 != nil:
    section.add "fields", valid_581009
  var valid_581010 = query.getOrDefault("quotaUser")
  valid_581010 = validateParameter(valid_581010, JString, required = false,
                                 default = nil)
  if valid_581010 != nil:
    section.add "quotaUser", valid_581010
  var valid_581011 = query.getOrDefault("alt")
  valid_581011 = validateParameter(valid_581011, JString, required = false,
                                 default = newJString("json"))
  if valid_581011 != nil:
    section.add "alt", valid_581011
  var valid_581012 = query.getOrDefault("oauth_token")
  valid_581012 = validateParameter(valid_581012, JString, required = false,
                                 default = nil)
  if valid_581012 != nil:
    section.add "oauth_token", valid_581012
  var valid_581013 = query.getOrDefault("callback")
  valid_581013 = validateParameter(valid_581013, JString, required = false,
                                 default = nil)
  if valid_581013 != nil:
    section.add "callback", valid_581013
  var valid_581014 = query.getOrDefault("access_token")
  valid_581014 = validateParameter(valid_581014, JString, required = false,
                                 default = nil)
  if valid_581014 != nil:
    section.add "access_token", valid_581014
  var valid_581015 = query.getOrDefault("uploadType")
  valid_581015 = validateParameter(valid_581015, JString, required = false,
                                 default = nil)
  if valid_581015 != nil:
    section.add "uploadType", valid_581015
  var valid_581016 = query.getOrDefault("key")
  valid_581016 = validateParameter(valid_581016, JString, required = false,
                                 default = nil)
  if valid_581016 != nil:
    section.add "key", valid_581016
  var valid_581017 = query.getOrDefault("$.xgafv")
  valid_581017 = validateParameter(valid_581017, JString, required = false,
                                 default = newJString("1"))
  if valid_581017 != nil:
    section.add "$.xgafv", valid_581017
  var valid_581018 = query.getOrDefault("prettyPrint")
  valid_581018 = validateParameter(valid_581018, JBool, required = false,
                                 default = newJBool(true))
  if valid_581018 != nil:
    section.add "prettyPrint", valid_581018
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

proc call*(call_581020: Call_ContainerProjectsLocationsClustersSetResourceLabels_581004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets labels on a cluster.
  ## 
  let valid = call_581020.validator(path, query, header, formData, body)
  let scheme = call_581020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581020.url(scheme.get, call_581020.host, call_581020.base,
                         call_581020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581020, url, valid)

proc call*(call_581021: Call_ContainerProjectsLocationsClustersSetResourceLabels_581004;
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
  var path_581022 = newJObject()
  var query_581023 = newJObject()
  var body_581024 = newJObject()
  add(query_581023, "upload_protocol", newJString(uploadProtocol))
  add(query_581023, "fields", newJString(fields))
  add(query_581023, "quotaUser", newJString(quotaUser))
  add(path_581022, "name", newJString(name))
  add(query_581023, "alt", newJString(alt))
  add(query_581023, "oauth_token", newJString(oauthToken))
  add(query_581023, "callback", newJString(callback))
  add(query_581023, "access_token", newJString(accessToken))
  add(query_581023, "uploadType", newJString(uploadType))
  add(query_581023, "key", newJString(key))
  add(query_581023, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581024 = body
  add(query_581023, "prettyPrint", newJBool(prettyPrint))
  result = call_581021.call(path_581022, query_581023, nil, nil, body_581024)

var containerProjectsLocationsClustersSetResourceLabels* = Call_ContainerProjectsLocationsClustersSetResourceLabels_581004(
    name: "containerProjectsLocationsClustersSetResourceLabels",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setResourceLabels",
    validator: validate_ContainerProjectsLocationsClustersSetResourceLabels_581005,
    base: "/", url: url_ContainerProjectsLocationsClustersSetResourceLabels_581006,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsSetSize_581025 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsSetSize_581027(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsSetSize_581026(
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
  var valid_581028 = path.getOrDefault("name")
  valid_581028 = validateParameter(valid_581028, JString, required = true,
                                 default = nil)
  if valid_581028 != nil:
    section.add "name", valid_581028
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
  var valid_581029 = query.getOrDefault("upload_protocol")
  valid_581029 = validateParameter(valid_581029, JString, required = false,
                                 default = nil)
  if valid_581029 != nil:
    section.add "upload_protocol", valid_581029
  var valid_581030 = query.getOrDefault("fields")
  valid_581030 = validateParameter(valid_581030, JString, required = false,
                                 default = nil)
  if valid_581030 != nil:
    section.add "fields", valid_581030
  var valid_581031 = query.getOrDefault("quotaUser")
  valid_581031 = validateParameter(valid_581031, JString, required = false,
                                 default = nil)
  if valid_581031 != nil:
    section.add "quotaUser", valid_581031
  var valid_581032 = query.getOrDefault("alt")
  valid_581032 = validateParameter(valid_581032, JString, required = false,
                                 default = newJString("json"))
  if valid_581032 != nil:
    section.add "alt", valid_581032
  var valid_581033 = query.getOrDefault("oauth_token")
  valid_581033 = validateParameter(valid_581033, JString, required = false,
                                 default = nil)
  if valid_581033 != nil:
    section.add "oauth_token", valid_581033
  var valid_581034 = query.getOrDefault("callback")
  valid_581034 = validateParameter(valid_581034, JString, required = false,
                                 default = nil)
  if valid_581034 != nil:
    section.add "callback", valid_581034
  var valid_581035 = query.getOrDefault("access_token")
  valid_581035 = validateParameter(valid_581035, JString, required = false,
                                 default = nil)
  if valid_581035 != nil:
    section.add "access_token", valid_581035
  var valid_581036 = query.getOrDefault("uploadType")
  valid_581036 = validateParameter(valid_581036, JString, required = false,
                                 default = nil)
  if valid_581036 != nil:
    section.add "uploadType", valid_581036
  var valid_581037 = query.getOrDefault("key")
  valid_581037 = validateParameter(valid_581037, JString, required = false,
                                 default = nil)
  if valid_581037 != nil:
    section.add "key", valid_581037
  var valid_581038 = query.getOrDefault("$.xgafv")
  valid_581038 = validateParameter(valid_581038, JString, required = false,
                                 default = newJString("1"))
  if valid_581038 != nil:
    section.add "$.xgafv", valid_581038
  var valid_581039 = query.getOrDefault("prettyPrint")
  valid_581039 = validateParameter(valid_581039, JBool, required = false,
                                 default = newJBool(true))
  if valid_581039 != nil:
    section.add "prettyPrint", valid_581039
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

proc call*(call_581041: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_581025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the size for a specific node pool.
  ## 
  let valid = call_581041.validator(path, query, header, formData, body)
  let scheme = call_581041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581041.url(scheme.get, call_581041.host, call_581041.base,
                         call_581041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581041, url, valid)

proc call*(call_581042: Call_ContainerProjectsLocationsClustersNodePoolsSetSize_581025;
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
  var path_581043 = newJObject()
  var query_581044 = newJObject()
  var body_581045 = newJObject()
  add(query_581044, "upload_protocol", newJString(uploadProtocol))
  add(query_581044, "fields", newJString(fields))
  add(query_581044, "quotaUser", newJString(quotaUser))
  add(path_581043, "name", newJString(name))
  add(query_581044, "alt", newJString(alt))
  add(query_581044, "oauth_token", newJString(oauthToken))
  add(query_581044, "callback", newJString(callback))
  add(query_581044, "access_token", newJString(accessToken))
  add(query_581044, "uploadType", newJString(uploadType))
  add(query_581044, "key", newJString(key))
  add(query_581044, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581045 = body
  add(query_581044, "prettyPrint", newJBool(prettyPrint))
  result = call_581042.call(path_581043, query_581044, nil, nil, body_581045)

var containerProjectsLocationsClustersNodePoolsSetSize* = Call_ContainerProjectsLocationsClustersNodePoolsSetSize_581025(
    name: "containerProjectsLocationsClustersNodePoolsSetSize",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:setSize",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsSetSize_581026,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsSetSize_581027,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersStartIpRotation_581046 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersStartIpRotation_581048(
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

proc validate_ContainerProjectsLocationsClustersStartIpRotation_581047(
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
  var valid_581049 = path.getOrDefault("name")
  valid_581049 = validateParameter(valid_581049, JString, required = true,
                                 default = nil)
  if valid_581049 != nil:
    section.add "name", valid_581049
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
  var valid_581050 = query.getOrDefault("upload_protocol")
  valid_581050 = validateParameter(valid_581050, JString, required = false,
                                 default = nil)
  if valid_581050 != nil:
    section.add "upload_protocol", valid_581050
  var valid_581051 = query.getOrDefault("fields")
  valid_581051 = validateParameter(valid_581051, JString, required = false,
                                 default = nil)
  if valid_581051 != nil:
    section.add "fields", valid_581051
  var valid_581052 = query.getOrDefault("quotaUser")
  valid_581052 = validateParameter(valid_581052, JString, required = false,
                                 default = nil)
  if valid_581052 != nil:
    section.add "quotaUser", valid_581052
  var valid_581053 = query.getOrDefault("alt")
  valid_581053 = validateParameter(valid_581053, JString, required = false,
                                 default = newJString("json"))
  if valid_581053 != nil:
    section.add "alt", valid_581053
  var valid_581054 = query.getOrDefault("oauth_token")
  valid_581054 = validateParameter(valid_581054, JString, required = false,
                                 default = nil)
  if valid_581054 != nil:
    section.add "oauth_token", valid_581054
  var valid_581055 = query.getOrDefault("callback")
  valid_581055 = validateParameter(valid_581055, JString, required = false,
                                 default = nil)
  if valid_581055 != nil:
    section.add "callback", valid_581055
  var valid_581056 = query.getOrDefault("access_token")
  valid_581056 = validateParameter(valid_581056, JString, required = false,
                                 default = nil)
  if valid_581056 != nil:
    section.add "access_token", valid_581056
  var valid_581057 = query.getOrDefault("uploadType")
  valid_581057 = validateParameter(valid_581057, JString, required = false,
                                 default = nil)
  if valid_581057 != nil:
    section.add "uploadType", valid_581057
  var valid_581058 = query.getOrDefault("key")
  valid_581058 = validateParameter(valid_581058, JString, required = false,
                                 default = nil)
  if valid_581058 != nil:
    section.add "key", valid_581058
  var valid_581059 = query.getOrDefault("$.xgafv")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = newJString("1"))
  if valid_581059 != nil:
    section.add "$.xgafv", valid_581059
  var valid_581060 = query.getOrDefault("prettyPrint")
  valid_581060 = validateParameter(valid_581060, JBool, required = false,
                                 default = newJBool(true))
  if valid_581060 != nil:
    section.add "prettyPrint", valid_581060
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

proc call*(call_581062: Call_ContainerProjectsLocationsClustersStartIpRotation_581046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts master IP rotation.
  ## 
  let valid = call_581062.validator(path, query, header, formData, body)
  let scheme = call_581062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581062.url(scheme.get, call_581062.host, call_581062.base,
                         call_581062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581062, url, valid)

proc call*(call_581063: Call_ContainerProjectsLocationsClustersStartIpRotation_581046;
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
  var path_581064 = newJObject()
  var query_581065 = newJObject()
  var body_581066 = newJObject()
  add(query_581065, "upload_protocol", newJString(uploadProtocol))
  add(query_581065, "fields", newJString(fields))
  add(query_581065, "quotaUser", newJString(quotaUser))
  add(path_581064, "name", newJString(name))
  add(query_581065, "alt", newJString(alt))
  add(query_581065, "oauth_token", newJString(oauthToken))
  add(query_581065, "callback", newJString(callback))
  add(query_581065, "access_token", newJString(accessToken))
  add(query_581065, "uploadType", newJString(uploadType))
  add(query_581065, "key", newJString(key))
  add(query_581065, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581066 = body
  add(query_581065, "prettyPrint", newJBool(prettyPrint))
  result = call_581063.call(path_581064, query_581065, nil, nil, body_581066)

var containerProjectsLocationsClustersStartIpRotation* = Call_ContainerProjectsLocationsClustersStartIpRotation_581046(
    name: "containerProjectsLocationsClustersStartIpRotation",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:startIpRotation",
    validator: validate_ContainerProjectsLocationsClustersStartIpRotation_581047,
    base: "/", url: url_ContainerProjectsLocationsClustersStartIpRotation_581048,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersUpdateMaster_581067 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersUpdateMaster_581069(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersUpdateMaster_581068(
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
  var valid_581070 = path.getOrDefault("name")
  valid_581070 = validateParameter(valid_581070, JString, required = true,
                                 default = nil)
  if valid_581070 != nil:
    section.add "name", valid_581070
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
  var valid_581071 = query.getOrDefault("upload_protocol")
  valid_581071 = validateParameter(valid_581071, JString, required = false,
                                 default = nil)
  if valid_581071 != nil:
    section.add "upload_protocol", valid_581071
  var valid_581072 = query.getOrDefault("fields")
  valid_581072 = validateParameter(valid_581072, JString, required = false,
                                 default = nil)
  if valid_581072 != nil:
    section.add "fields", valid_581072
  var valid_581073 = query.getOrDefault("quotaUser")
  valid_581073 = validateParameter(valid_581073, JString, required = false,
                                 default = nil)
  if valid_581073 != nil:
    section.add "quotaUser", valid_581073
  var valid_581074 = query.getOrDefault("alt")
  valid_581074 = validateParameter(valid_581074, JString, required = false,
                                 default = newJString("json"))
  if valid_581074 != nil:
    section.add "alt", valid_581074
  var valid_581075 = query.getOrDefault("oauth_token")
  valid_581075 = validateParameter(valid_581075, JString, required = false,
                                 default = nil)
  if valid_581075 != nil:
    section.add "oauth_token", valid_581075
  var valid_581076 = query.getOrDefault("callback")
  valid_581076 = validateParameter(valid_581076, JString, required = false,
                                 default = nil)
  if valid_581076 != nil:
    section.add "callback", valid_581076
  var valid_581077 = query.getOrDefault("access_token")
  valid_581077 = validateParameter(valid_581077, JString, required = false,
                                 default = nil)
  if valid_581077 != nil:
    section.add "access_token", valid_581077
  var valid_581078 = query.getOrDefault("uploadType")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = nil)
  if valid_581078 != nil:
    section.add "uploadType", valid_581078
  var valid_581079 = query.getOrDefault("key")
  valid_581079 = validateParameter(valid_581079, JString, required = false,
                                 default = nil)
  if valid_581079 != nil:
    section.add "key", valid_581079
  var valid_581080 = query.getOrDefault("$.xgafv")
  valid_581080 = validateParameter(valid_581080, JString, required = false,
                                 default = newJString("1"))
  if valid_581080 != nil:
    section.add "$.xgafv", valid_581080
  var valid_581081 = query.getOrDefault("prettyPrint")
  valid_581081 = validateParameter(valid_581081, JBool, required = false,
                                 default = newJBool(true))
  if valid_581081 != nil:
    section.add "prettyPrint", valid_581081
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

proc call*(call_581083: Call_ContainerProjectsLocationsClustersUpdateMaster_581067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the master for a specific cluster.
  ## 
  let valid = call_581083.validator(path, query, header, formData, body)
  let scheme = call_581083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581083.url(scheme.get, call_581083.host, call_581083.base,
                         call_581083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581083, url, valid)

proc call*(call_581084: Call_ContainerProjectsLocationsClustersUpdateMaster_581067;
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
  var path_581085 = newJObject()
  var query_581086 = newJObject()
  var body_581087 = newJObject()
  add(query_581086, "upload_protocol", newJString(uploadProtocol))
  add(query_581086, "fields", newJString(fields))
  add(query_581086, "quotaUser", newJString(quotaUser))
  add(path_581085, "name", newJString(name))
  add(query_581086, "alt", newJString(alt))
  add(query_581086, "oauth_token", newJString(oauthToken))
  add(query_581086, "callback", newJString(callback))
  add(query_581086, "access_token", newJString(accessToken))
  add(query_581086, "uploadType", newJString(uploadType))
  add(query_581086, "key", newJString(key))
  add(query_581086, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581087 = body
  add(query_581086, "prettyPrint", newJBool(prettyPrint))
  result = call_581084.call(path_581085, query_581086, nil, nil, body_581087)

var containerProjectsLocationsClustersUpdateMaster* = Call_ContainerProjectsLocationsClustersUpdateMaster_581067(
    name: "containerProjectsLocationsClustersUpdateMaster",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{name}:updateMaster",
    validator: validate_ContainerProjectsLocationsClustersUpdateMaster_581068,
    base: "/", url: url_ContainerProjectsLocationsClustersUpdateMaster_581069,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581088 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581090(
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

proc validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581089(
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
  var valid_581091 = path.getOrDefault("parent")
  valid_581091 = validateParameter(valid_581091, JString, required = true,
                                 default = nil)
  if valid_581091 != nil:
    section.add "parent", valid_581091
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
  var valid_581092 = query.getOrDefault("upload_protocol")
  valid_581092 = validateParameter(valid_581092, JString, required = false,
                                 default = nil)
  if valid_581092 != nil:
    section.add "upload_protocol", valid_581092
  var valid_581093 = query.getOrDefault("fields")
  valid_581093 = validateParameter(valid_581093, JString, required = false,
                                 default = nil)
  if valid_581093 != nil:
    section.add "fields", valid_581093
  var valid_581094 = query.getOrDefault("quotaUser")
  valid_581094 = validateParameter(valid_581094, JString, required = false,
                                 default = nil)
  if valid_581094 != nil:
    section.add "quotaUser", valid_581094
  var valid_581095 = query.getOrDefault("alt")
  valid_581095 = validateParameter(valid_581095, JString, required = false,
                                 default = newJString("json"))
  if valid_581095 != nil:
    section.add "alt", valid_581095
  var valid_581096 = query.getOrDefault("oauth_token")
  valid_581096 = validateParameter(valid_581096, JString, required = false,
                                 default = nil)
  if valid_581096 != nil:
    section.add "oauth_token", valid_581096
  var valid_581097 = query.getOrDefault("callback")
  valid_581097 = validateParameter(valid_581097, JString, required = false,
                                 default = nil)
  if valid_581097 != nil:
    section.add "callback", valid_581097
  var valid_581098 = query.getOrDefault("access_token")
  valid_581098 = validateParameter(valid_581098, JString, required = false,
                                 default = nil)
  if valid_581098 != nil:
    section.add "access_token", valid_581098
  var valid_581099 = query.getOrDefault("uploadType")
  valid_581099 = validateParameter(valid_581099, JString, required = false,
                                 default = nil)
  if valid_581099 != nil:
    section.add "uploadType", valid_581099
  var valid_581100 = query.getOrDefault("key")
  valid_581100 = validateParameter(valid_581100, JString, required = false,
                                 default = nil)
  if valid_581100 != nil:
    section.add "key", valid_581100
  var valid_581101 = query.getOrDefault("$.xgafv")
  valid_581101 = validateParameter(valid_581101, JString, required = false,
                                 default = newJString("1"))
  if valid_581101 != nil:
    section.add "$.xgafv", valid_581101
  var valid_581102 = query.getOrDefault("prettyPrint")
  valid_581102 = validateParameter(valid_581102, JBool, required = false,
                                 default = newJBool(true))
  if valid_581102 != nil:
    section.add "prettyPrint", valid_581102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581103: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581088;
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
  let valid = call_581103.validator(path, query, header, formData, body)
  let scheme = call_581103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581103.url(scheme.get, call_581103.host, call_581103.base,
                         call_581103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581103, url, valid)

proc call*(call_581104: Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581088;
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
  var path_581105 = newJObject()
  var query_581106 = newJObject()
  add(query_581106, "upload_protocol", newJString(uploadProtocol))
  add(query_581106, "fields", newJString(fields))
  add(query_581106, "quotaUser", newJString(quotaUser))
  add(query_581106, "alt", newJString(alt))
  add(query_581106, "oauth_token", newJString(oauthToken))
  add(query_581106, "callback", newJString(callback))
  add(query_581106, "access_token", newJString(accessToken))
  add(query_581106, "uploadType", newJString(uploadType))
  add(path_581105, "parent", newJString(parent))
  add(query_581106, "key", newJString(key))
  add(query_581106, "$.xgafv", newJString(Xgafv))
  add(query_581106, "prettyPrint", newJBool(prettyPrint))
  result = call_581104.call(path_581105, query_581106, nil, nil, nil)

var containerProjectsLocationsClustersWellKnownGetOpenidConfiguration* = Call_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581088(
    name: "containerProjectsLocationsClustersWellKnownGetOpenidConfiguration",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/.well-known/openid-configuration", validator: validate_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581089,
    base: "/",
    url: url_ContainerProjectsLocationsClustersWellKnownGetOpenidConfiguration_581090,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsAggregatedUsableSubnetworksList_581107 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsAggregatedUsableSubnetworksList_581109(
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

proc validate_ContainerProjectsAggregatedUsableSubnetworksList_581108(
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
  var valid_581110 = path.getOrDefault("parent")
  valid_581110 = validateParameter(valid_581110, JString, required = true,
                                 default = nil)
  if valid_581110 != nil:
    section.add "parent", valid_581110
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
  var valid_581111 = query.getOrDefault("upload_protocol")
  valid_581111 = validateParameter(valid_581111, JString, required = false,
                                 default = nil)
  if valid_581111 != nil:
    section.add "upload_protocol", valid_581111
  var valid_581112 = query.getOrDefault("fields")
  valid_581112 = validateParameter(valid_581112, JString, required = false,
                                 default = nil)
  if valid_581112 != nil:
    section.add "fields", valid_581112
  var valid_581113 = query.getOrDefault("pageToken")
  valid_581113 = validateParameter(valid_581113, JString, required = false,
                                 default = nil)
  if valid_581113 != nil:
    section.add "pageToken", valid_581113
  var valid_581114 = query.getOrDefault("quotaUser")
  valid_581114 = validateParameter(valid_581114, JString, required = false,
                                 default = nil)
  if valid_581114 != nil:
    section.add "quotaUser", valid_581114
  var valid_581115 = query.getOrDefault("alt")
  valid_581115 = validateParameter(valid_581115, JString, required = false,
                                 default = newJString("json"))
  if valid_581115 != nil:
    section.add "alt", valid_581115
  var valid_581116 = query.getOrDefault("oauth_token")
  valid_581116 = validateParameter(valid_581116, JString, required = false,
                                 default = nil)
  if valid_581116 != nil:
    section.add "oauth_token", valid_581116
  var valid_581117 = query.getOrDefault("callback")
  valid_581117 = validateParameter(valid_581117, JString, required = false,
                                 default = nil)
  if valid_581117 != nil:
    section.add "callback", valid_581117
  var valid_581118 = query.getOrDefault("access_token")
  valid_581118 = validateParameter(valid_581118, JString, required = false,
                                 default = nil)
  if valid_581118 != nil:
    section.add "access_token", valid_581118
  var valid_581119 = query.getOrDefault("uploadType")
  valid_581119 = validateParameter(valid_581119, JString, required = false,
                                 default = nil)
  if valid_581119 != nil:
    section.add "uploadType", valid_581119
  var valid_581120 = query.getOrDefault("key")
  valid_581120 = validateParameter(valid_581120, JString, required = false,
                                 default = nil)
  if valid_581120 != nil:
    section.add "key", valid_581120
  var valid_581121 = query.getOrDefault("$.xgafv")
  valid_581121 = validateParameter(valid_581121, JString, required = false,
                                 default = newJString("1"))
  if valid_581121 != nil:
    section.add "$.xgafv", valid_581121
  var valid_581122 = query.getOrDefault("pageSize")
  valid_581122 = validateParameter(valid_581122, JInt, required = false, default = nil)
  if valid_581122 != nil:
    section.add "pageSize", valid_581122
  var valid_581123 = query.getOrDefault("prettyPrint")
  valid_581123 = validateParameter(valid_581123, JBool, required = false,
                                 default = newJBool(true))
  if valid_581123 != nil:
    section.add "prettyPrint", valid_581123
  var valid_581124 = query.getOrDefault("filter")
  valid_581124 = validateParameter(valid_581124, JString, required = false,
                                 default = nil)
  if valid_581124 != nil:
    section.add "filter", valid_581124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581125: Call_ContainerProjectsAggregatedUsableSubnetworksList_581107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists subnetworks that are usable for creating clusters in a project.
  ## 
  let valid = call_581125.validator(path, query, header, formData, body)
  let scheme = call_581125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581125.url(scheme.get, call_581125.host, call_581125.base,
                         call_581125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581125, url, valid)

proc call*(call_581126: Call_ContainerProjectsAggregatedUsableSubnetworksList_581107;
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
  var path_581127 = newJObject()
  var query_581128 = newJObject()
  add(query_581128, "upload_protocol", newJString(uploadProtocol))
  add(query_581128, "fields", newJString(fields))
  add(query_581128, "pageToken", newJString(pageToken))
  add(query_581128, "quotaUser", newJString(quotaUser))
  add(query_581128, "alt", newJString(alt))
  add(query_581128, "oauth_token", newJString(oauthToken))
  add(query_581128, "callback", newJString(callback))
  add(query_581128, "access_token", newJString(accessToken))
  add(query_581128, "uploadType", newJString(uploadType))
  add(path_581127, "parent", newJString(parent))
  add(query_581128, "key", newJString(key))
  add(query_581128, "$.xgafv", newJString(Xgafv))
  add(query_581128, "pageSize", newJInt(pageSize))
  add(query_581128, "prettyPrint", newJBool(prettyPrint))
  add(query_581128, "filter", newJString(filter))
  result = call_581126.call(path_581127, query_581128, nil, nil, nil)

var containerProjectsAggregatedUsableSubnetworksList* = Call_ContainerProjectsAggregatedUsableSubnetworksList_581107(
    name: "containerProjectsAggregatedUsableSubnetworksList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/aggregated/usableSubnetworks",
    validator: validate_ContainerProjectsAggregatedUsableSubnetworksList_581108,
    base: "/", url: url_ContainerProjectsAggregatedUsableSubnetworksList_581109,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersCreate_581150 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersCreate_581152(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersCreate_581151(path: JsonNode;
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
  var valid_581153 = path.getOrDefault("parent")
  valid_581153 = validateParameter(valid_581153, JString, required = true,
                                 default = nil)
  if valid_581153 != nil:
    section.add "parent", valid_581153
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
  var valid_581154 = query.getOrDefault("upload_protocol")
  valid_581154 = validateParameter(valid_581154, JString, required = false,
                                 default = nil)
  if valid_581154 != nil:
    section.add "upload_protocol", valid_581154
  var valid_581155 = query.getOrDefault("fields")
  valid_581155 = validateParameter(valid_581155, JString, required = false,
                                 default = nil)
  if valid_581155 != nil:
    section.add "fields", valid_581155
  var valid_581156 = query.getOrDefault("quotaUser")
  valid_581156 = validateParameter(valid_581156, JString, required = false,
                                 default = nil)
  if valid_581156 != nil:
    section.add "quotaUser", valid_581156
  var valid_581157 = query.getOrDefault("alt")
  valid_581157 = validateParameter(valid_581157, JString, required = false,
                                 default = newJString("json"))
  if valid_581157 != nil:
    section.add "alt", valid_581157
  var valid_581158 = query.getOrDefault("oauth_token")
  valid_581158 = validateParameter(valid_581158, JString, required = false,
                                 default = nil)
  if valid_581158 != nil:
    section.add "oauth_token", valid_581158
  var valid_581159 = query.getOrDefault("callback")
  valid_581159 = validateParameter(valid_581159, JString, required = false,
                                 default = nil)
  if valid_581159 != nil:
    section.add "callback", valid_581159
  var valid_581160 = query.getOrDefault("access_token")
  valid_581160 = validateParameter(valid_581160, JString, required = false,
                                 default = nil)
  if valid_581160 != nil:
    section.add "access_token", valid_581160
  var valid_581161 = query.getOrDefault("uploadType")
  valid_581161 = validateParameter(valid_581161, JString, required = false,
                                 default = nil)
  if valid_581161 != nil:
    section.add "uploadType", valid_581161
  var valid_581162 = query.getOrDefault("key")
  valid_581162 = validateParameter(valid_581162, JString, required = false,
                                 default = nil)
  if valid_581162 != nil:
    section.add "key", valid_581162
  var valid_581163 = query.getOrDefault("$.xgafv")
  valid_581163 = validateParameter(valid_581163, JString, required = false,
                                 default = newJString("1"))
  if valid_581163 != nil:
    section.add "$.xgafv", valid_581163
  var valid_581164 = query.getOrDefault("prettyPrint")
  valid_581164 = validateParameter(valid_581164, JBool, required = false,
                                 default = newJBool(true))
  if valid_581164 != nil:
    section.add "prettyPrint", valid_581164
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

proc call*(call_581166: Call_ContainerProjectsLocationsClustersCreate_581150;
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
  let valid = call_581166.validator(path, query, header, formData, body)
  let scheme = call_581166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581166.url(scheme.get, call_581166.host, call_581166.base,
                         call_581166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581166, url, valid)

proc call*(call_581167: Call_ContainerProjectsLocationsClustersCreate_581150;
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
  var path_581168 = newJObject()
  var query_581169 = newJObject()
  var body_581170 = newJObject()
  add(query_581169, "upload_protocol", newJString(uploadProtocol))
  add(query_581169, "fields", newJString(fields))
  add(query_581169, "quotaUser", newJString(quotaUser))
  add(query_581169, "alt", newJString(alt))
  add(query_581169, "oauth_token", newJString(oauthToken))
  add(query_581169, "callback", newJString(callback))
  add(query_581169, "access_token", newJString(accessToken))
  add(query_581169, "uploadType", newJString(uploadType))
  add(path_581168, "parent", newJString(parent))
  add(query_581169, "key", newJString(key))
  add(query_581169, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581170 = body
  add(query_581169, "prettyPrint", newJBool(prettyPrint))
  result = call_581167.call(path_581168, query_581169, nil, nil, body_581170)

var containerProjectsLocationsClustersCreate* = Call_ContainerProjectsLocationsClustersCreate_581150(
    name: "containerProjectsLocationsClustersCreate", meth: HttpMethod.HttpPost,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersCreate_581151,
    base: "/", url: url_ContainerProjectsLocationsClustersCreate_581152,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersList_581129 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersList_581131(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersList_581130(path: JsonNode;
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
  var valid_581132 = path.getOrDefault("parent")
  valid_581132 = validateParameter(valid_581132, JString, required = true,
                                 default = nil)
  if valid_581132 != nil:
    section.add "parent", valid_581132
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
  var valid_581133 = query.getOrDefault("upload_protocol")
  valid_581133 = validateParameter(valid_581133, JString, required = false,
                                 default = nil)
  if valid_581133 != nil:
    section.add "upload_protocol", valid_581133
  var valid_581134 = query.getOrDefault("fields")
  valid_581134 = validateParameter(valid_581134, JString, required = false,
                                 default = nil)
  if valid_581134 != nil:
    section.add "fields", valid_581134
  var valid_581135 = query.getOrDefault("quotaUser")
  valid_581135 = validateParameter(valid_581135, JString, required = false,
                                 default = nil)
  if valid_581135 != nil:
    section.add "quotaUser", valid_581135
  var valid_581136 = query.getOrDefault("alt")
  valid_581136 = validateParameter(valid_581136, JString, required = false,
                                 default = newJString("json"))
  if valid_581136 != nil:
    section.add "alt", valid_581136
  var valid_581137 = query.getOrDefault("oauth_token")
  valid_581137 = validateParameter(valid_581137, JString, required = false,
                                 default = nil)
  if valid_581137 != nil:
    section.add "oauth_token", valid_581137
  var valid_581138 = query.getOrDefault("callback")
  valid_581138 = validateParameter(valid_581138, JString, required = false,
                                 default = nil)
  if valid_581138 != nil:
    section.add "callback", valid_581138
  var valid_581139 = query.getOrDefault("access_token")
  valid_581139 = validateParameter(valid_581139, JString, required = false,
                                 default = nil)
  if valid_581139 != nil:
    section.add "access_token", valid_581139
  var valid_581140 = query.getOrDefault("uploadType")
  valid_581140 = validateParameter(valid_581140, JString, required = false,
                                 default = nil)
  if valid_581140 != nil:
    section.add "uploadType", valid_581140
  var valid_581141 = query.getOrDefault("zone")
  valid_581141 = validateParameter(valid_581141, JString, required = false,
                                 default = nil)
  if valid_581141 != nil:
    section.add "zone", valid_581141
  var valid_581142 = query.getOrDefault("key")
  valid_581142 = validateParameter(valid_581142, JString, required = false,
                                 default = nil)
  if valid_581142 != nil:
    section.add "key", valid_581142
  var valid_581143 = query.getOrDefault("$.xgafv")
  valid_581143 = validateParameter(valid_581143, JString, required = false,
                                 default = newJString("1"))
  if valid_581143 != nil:
    section.add "$.xgafv", valid_581143
  var valid_581144 = query.getOrDefault("projectId")
  valid_581144 = validateParameter(valid_581144, JString, required = false,
                                 default = nil)
  if valid_581144 != nil:
    section.add "projectId", valid_581144
  var valid_581145 = query.getOrDefault("prettyPrint")
  valid_581145 = validateParameter(valid_581145, JBool, required = false,
                                 default = newJBool(true))
  if valid_581145 != nil:
    section.add "prettyPrint", valid_581145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581146: Call_ContainerProjectsLocationsClustersList_581129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all clusters owned by a project in either the specified zone or all
  ## zones.
  ## 
  let valid = call_581146.validator(path, query, header, formData, body)
  let scheme = call_581146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581146.url(scheme.get, call_581146.host, call_581146.base,
                         call_581146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581146, url, valid)

proc call*(call_581147: Call_ContainerProjectsLocationsClustersList_581129;
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
  var path_581148 = newJObject()
  var query_581149 = newJObject()
  add(query_581149, "upload_protocol", newJString(uploadProtocol))
  add(query_581149, "fields", newJString(fields))
  add(query_581149, "quotaUser", newJString(quotaUser))
  add(query_581149, "alt", newJString(alt))
  add(query_581149, "oauth_token", newJString(oauthToken))
  add(query_581149, "callback", newJString(callback))
  add(query_581149, "access_token", newJString(accessToken))
  add(query_581149, "uploadType", newJString(uploadType))
  add(path_581148, "parent", newJString(parent))
  add(query_581149, "zone", newJString(zone))
  add(query_581149, "key", newJString(key))
  add(query_581149, "$.xgafv", newJString(Xgafv))
  add(query_581149, "projectId", newJString(projectId))
  add(query_581149, "prettyPrint", newJBool(prettyPrint))
  result = call_581147.call(path_581148, query_581149, nil, nil, nil)

var containerProjectsLocationsClustersList* = Call_ContainerProjectsLocationsClustersList_581129(
    name: "containerProjectsLocationsClustersList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/clusters",
    validator: validate_ContainerProjectsLocationsClustersList_581130, base: "/",
    url: url_ContainerProjectsLocationsClustersList_581131,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersGetJwks_581171 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersGetJwks_581173(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersGetJwks_581172(path: JsonNode;
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
  var valid_581174 = path.getOrDefault("parent")
  valid_581174 = validateParameter(valid_581174, JString, required = true,
                                 default = nil)
  if valid_581174 != nil:
    section.add "parent", valid_581174
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
  var valid_581175 = query.getOrDefault("upload_protocol")
  valid_581175 = validateParameter(valid_581175, JString, required = false,
                                 default = nil)
  if valid_581175 != nil:
    section.add "upload_protocol", valid_581175
  var valid_581176 = query.getOrDefault("fields")
  valid_581176 = validateParameter(valid_581176, JString, required = false,
                                 default = nil)
  if valid_581176 != nil:
    section.add "fields", valid_581176
  var valid_581177 = query.getOrDefault("quotaUser")
  valid_581177 = validateParameter(valid_581177, JString, required = false,
                                 default = nil)
  if valid_581177 != nil:
    section.add "quotaUser", valid_581177
  var valid_581178 = query.getOrDefault("alt")
  valid_581178 = validateParameter(valid_581178, JString, required = false,
                                 default = newJString("json"))
  if valid_581178 != nil:
    section.add "alt", valid_581178
  var valid_581179 = query.getOrDefault("oauth_token")
  valid_581179 = validateParameter(valid_581179, JString, required = false,
                                 default = nil)
  if valid_581179 != nil:
    section.add "oauth_token", valid_581179
  var valid_581180 = query.getOrDefault("callback")
  valid_581180 = validateParameter(valid_581180, JString, required = false,
                                 default = nil)
  if valid_581180 != nil:
    section.add "callback", valid_581180
  var valid_581181 = query.getOrDefault("access_token")
  valid_581181 = validateParameter(valid_581181, JString, required = false,
                                 default = nil)
  if valid_581181 != nil:
    section.add "access_token", valid_581181
  var valid_581182 = query.getOrDefault("uploadType")
  valid_581182 = validateParameter(valid_581182, JString, required = false,
                                 default = nil)
  if valid_581182 != nil:
    section.add "uploadType", valid_581182
  var valid_581183 = query.getOrDefault("key")
  valid_581183 = validateParameter(valid_581183, JString, required = false,
                                 default = nil)
  if valid_581183 != nil:
    section.add "key", valid_581183
  var valid_581184 = query.getOrDefault("$.xgafv")
  valid_581184 = validateParameter(valid_581184, JString, required = false,
                                 default = newJString("1"))
  if valid_581184 != nil:
    section.add "$.xgafv", valid_581184
  var valid_581185 = query.getOrDefault("prettyPrint")
  valid_581185 = validateParameter(valid_581185, JBool, required = false,
                                 default = newJBool(true))
  if valid_581185 != nil:
    section.add "prettyPrint", valid_581185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581186: Call_ContainerProjectsLocationsClustersGetJwks_581171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the public component of the cluster signing keys in
  ## JSON Web Key format.
  ## This API is not yet intended for general use, and is not available for all
  ## clusters.
  ## 
  let valid = call_581186.validator(path, query, header, formData, body)
  let scheme = call_581186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581186.url(scheme.get, call_581186.host, call_581186.base,
                         call_581186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581186, url, valid)

proc call*(call_581187: Call_ContainerProjectsLocationsClustersGetJwks_581171;
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
  var path_581188 = newJObject()
  var query_581189 = newJObject()
  add(query_581189, "upload_protocol", newJString(uploadProtocol))
  add(query_581189, "fields", newJString(fields))
  add(query_581189, "quotaUser", newJString(quotaUser))
  add(query_581189, "alt", newJString(alt))
  add(query_581189, "oauth_token", newJString(oauthToken))
  add(query_581189, "callback", newJString(callback))
  add(query_581189, "access_token", newJString(accessToken))
  add(query_581189, "uploadType", newJString(uploadType))
  add(path_581188, "parent", newJString(parent))
  add(query_581189, "key", newJString(key))
  add(query_581189, "$.xgafv", newJString(Xgafv))
  add(query_581189, "prettyPrint", newJBool(prettyPrint))
  result = call_581187.call(path_581188, query_581189, nil, nil, nil)

var containerProjectsLocationsClustersGetJwks* = Call_ContainerProjectsLocationsClustersGetJwks_581171(
    name: "containerProjectsLocationsClustersGetJwks", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/jwks",
    validator: validate_ContainerProjectsLocationsClustersGetJwks_581172,
    base: "/", url: url_ContainerProjectsLocationsClustersGetJwks_581173,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsCreate_581212 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsCreate_581214(
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

proc validate_ContainerProjectsLocationsClustersNodePoolsCreate_581213(
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
  var valid_581215 = path.getOrDefault("parent")
  valid_581215 = validateParameter(valid_581215, JString, required = true,
                                 default = nil)
  if valid_581215 != nil:
    section.add "parent", valid_581215
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
  var valid_581216 = query.getOrDefault("upload_protocol")
  valid_581216 = validateParameter(valid_581216, JString, required = false,
                                 default = nil)
  if valid_581216 != nil:
    section.add "upload_protocol", valid_581216
  var valid_581217 = query.getOrDefault("fields")
  valid_581217 = validateParameter(valid_581217, JString, required = false,
                                 default = nil)
  if valid_581217 != nil:
    section.add "fields", valid_581217
  var valid_581218 = query.getOrDefault("quotaUser")
  valid_581218 = validateParameter(valid_581218, JString, required = false,
                                 default = nil)
  if valid_581218 != nil:
    section.add "quotaUser", valid_581218
  var valid_581219 = query.getOrDefault("alt")
  valid_581219 = validateParameter(valid_581219, JString, required = false,
                                 default = newJString("json"))
  if valid_581219 != nil:
    section.add "alt", valid_581219
  var valid_581220 = query.getOrDefault("oauth_token")
  valid_581220 = validateParameter(valid_581220, JString, required = false,
                                 default = nil)
  if valid_581220 != nil:
    section.add "oauth_token", valid_581220
  var valid_581221 = query.getOrDefault("callback")
  valid_581221 = validateParameter(valid_581221, JString, required = false,
                                 default = nil)
  if valid_581221 != nil:
    section.add "callback", valid_581221
  var valid_581222 = query.getOrDefault("access_token")
  valid_581222 = validateParameter(valid_581222, JString, required = false,
                                 default = nil)
  if valid_581222 != nil:
    section.add "access_token", valid_581222
  var valid_581223 = query.getOrDefault("uploadType")
  valid_581223 = validateParameter(valid_581223, JString, required = false,
                                 default = nil)
  if valid_581223 != nil:
    section.add "uploadType", valid_581223
  var valid_581224 = query.getOrDefault("key")
  valid_581224 = validateParameter(valid_581224, JString, required = false,
                                 default = nil)
  if valid_581224 != nil:
    section.add "key", valid_581224
  var valid_581225 = query.getOrDefault("$.xgafv")
  valid_581225 = validateParameter(valid_581225, JString, required = false,
                                 default = newJString("1"))
  if valid_581225 != nil:
    section.add "$.xgafv", valid_581225
  var valid_581226 = query.getOrDefault("prettyPrint")
  valid_581226 = validateParameter(valid_581226, JBool, required = false,
                                 default = newJBool(true))
  if valid_581226 != nil:
    section.add "prettyPrint", valid_581226
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

proc call*(call_581228: Call_ContainerProjectsLocationsClustersNodePoolsCreate_581212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node pool for a cluster.
  ## 
  let valid = call_581228.validator(path, query, header, formData, body)
  let scheme = call_581228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581228.url(scheme.get, call_581228.host, call_581228.base,
                         call_581228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581228, url, valid)

proc call*(call_581229: Call_ContainerProjectsLocationsClustersNodePoolsCreate_581212;
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
  var path_581230 = newJObject()
  var query_581231 = newJObject()
  var body_581232 = newJObject()
  add(query_581231, "upload_protocol", newJString(uploadProtocol))
  add(query_581231, "fields", newJString(fields))
  add(query_581231, "quotaUser", newJString(quotaUser))
  add(query_581231, "alt", newJString(alt))
  add(query_581231, "oauth_token", newJString(oauthToken))
  add(query_581231, "callback", newJString(callback))
  add(query_581231, "access_token", newJString(accessToken))
  add(query_581231, "uploadType", newJString(uploadType))
  add(path_581230, "parent", newJString(parent))
  add(query_581231, "key", newJString(key))
  add(query_581231, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_581232 = body
  add(query_581231, "prettyPrint", newJBool(prettyPrint))
  result = call_581229.call(path_581230, query_581231, nil, nil, body_581232)

var containerProjectsLocationsClustersNodePoolsCreate* = Call_ContainerProjectsLocationsClustersNodePoolsCreate_581212(
    name: "containerProjectsLocationsClustersNodePoolsCreate",
    meth: HttpMethod.HttpPost, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsCreate_581213,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsCreate_581214,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsClustersNodePoolsList_581190 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsClustersNodePoolsList_581192(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsClustersNodePoolsList_581191(
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
  var valid_581193 = path.getOrDefault("parent")
  valid_581193 = validateParameter(valid_581193, JString, required = true,
                                 default = nil)
  if valid_581193 != nil:
    section.add "parent", valid_581193
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
  var valid_581194 = query.getOrDefault("upload_protocol")
  valid_581194 = validateParameter(valid_581194, JString, required = false,
                                 default = nil)
  if valid_581194 != nil:
    section.add "upload_protocol", valid_581194
  var valid_581195 = query.getOrDefault("fields")
  valid_581195 = validateParameter(valid_581195, JString, required = false,
                                 default = nil)
  if valid_581195 != nil:
    section.add "fields", valid_581195
  var valid_581196 = query.getOrDefault("quotaUser")
  valid_581196 = validateParameter(valid_581196, JString, required = false,
                                 default = nil)
  if valid_581196 != nil:
    section.add "quotaUser", valid_581196
  var valid_581197 = query.getOrDefault("alt")
  valid_581197 = validateParameter(valid_581197, JString, required = false,
                                 default = newJString("json"))
  if valid_581197 != nil:
    section.add "alt", valid_581197
  var valid_581198 = query.getOrDefault("oauth_token")
  valid_581198 = validateParameter(valid_581198, JString, required = false,
                                 default = nil)
  if valid_581198 != nil:
    section.add "oauth_token", valid_581198
  var valid_581199 = query.getOrDefault("callback")
  valid_581199 = validateParameter(valid_581199, JString, required = false,
                                 default = nil)
  if valid_581199 != nil:
    section.add "callback", valid_581199
  var valid_581200 = query.getOrDefault("access_token")
  valid_581200 = validateParameter(valid_581200, JString, required = false,
                                 default = nil)
  if valid_581200 != nil:
    section.add "access_token", valid_581200
  var valid_581201 = query.getOrDefault("uploadType")
  valid_581201 = validateParameter(valid_581201, JString, required = false,
                                 default = nil)
  if valid_581201 != nil:
    section.add "uploadType", valid_581201
  var valid_581202 = query.getOrDefault("zone")
  valid_581202 = validateParameter(valid_581202, JString, required = false,
                                 default = nil)
  if valid_581202 != nil:
    section.add "zone", valid_581202
  var valid_581203 = query.getOrDefault("key")
  valid_581203 = validateParameter(valid_581203, JString, required = false,
                                 default = nil)
  if valid_581203 != nil:
    section.add "key", valid_581203
  var valid_581204 = query.getOrDefault("$.xgafv")
  valid_581204 = validateParameter(valid_581204, JString, required = false,
                                 default = newJString("1"))
  if valid_581204 != nil:
    section.add "$.xgafv", valid_581204
  var valid_581205 = query.getOrDefault("projectId")
  valid_581205 = validateParameter(valid_581205, JString, required = false,
                                 default = nil)
  if valid_581205 != nil:
    section.add "projectId", valid_581205
  var valid_581206 = query.getOrDefault("prettyPrint")
  valid_581206 = validateParameter(valid_581206, JBool, required = false,
                                 default = newJBool(true))
  if valid_581206 != nil:
    section.add "prettyPrint", valid_581206
  var valid_581207 = query.getOrDefault("clusterId")
  valid_581207 = validateParameter(valid_581207, JString, required = false,
                                 default = nil)
  if valid_581207 != nil:
    section.add "clusterId", valid_581207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581208: Call_ContainerProjectsLocationsClustersNodePoolsList_581190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the node pools for a cluster.
  ## 
  let valid = call_581208.validator(path, query, header, formData, body)
  let scheme = call_581208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581208.url(scheme.get, call_581208.host, call_581208.base,
                         call_581208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581208, url, valid)

proc call*(call_581209: Call_ContainerProjectsLocationsClustersNodePoolsList_581190;
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
  var path_581210 = newJObject()
  var query_581211 = newJObject()
  add(query_581211, "upload_protocol", newJString(uploadProtocol))
  add(query_581211, "fields", newJString(fields))
  add(query_581211, "quotaUser", newJString(quotaUser))
  add(query_581211, "alt", newJString(alt))
  add(query_581211, "oauth_token", newJString(oauthToken))
  add(query_581211, "callback", newJString(callback))
  add(query_581211, "access_token", newJString(accessToken))
  add(query_581211, "uploadType", newJString(uploadType))
  add(path_581210, "parent", newJString(parent))
  add(query_581211, "zone", newJString(zone))
  add(query_581211, "key", newJString(key))
  add(query_581211, "$.xgafv", newJString(Xgafv))
  add(query_581211, "projectId", newJString(projectId))
  add(query_581211, "prettyPrint", newJBool(prettyPrint))
  add(query_581211, "clusterId", newJString(clusterId))
  result = call_581209.call(path_581210, query_581211, nil, nil, nil)

var containerProjectsLocationsClustersNodePoolsList* = Call_ContainerProjectsLocationsClustersNodePoolsList_581190(
    name: "containerProjectsLocationsClustersNodePoolsList",
    meth: HttpMethod.HttpGet, host: "container.googleapis.com",
    route: "/v1/{parent}/nodePools",
    validator: validate_ContainerProjectsLocationsClustersNodePoolsList_581191,
    base: "/", url: url_ContainerProjectsLocationsClustersNodePoolsList_581192,
    schemes: {Scheme.Https})
type
  Call_ContainerProjectsLocationsOperationsList_581233 = ref object of OpenApiRestCall_579421
proc url_ContainerProjectsLocationsOperationsList_581235(protocol: Scheme;
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

proc validate_ContainerProjectsLocationsOperationsList_581234(path: JsonNode;
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
  var valid_581236 = path.getOrDefault("parent")
  valid_581236 = validateParameter(valid_581236, JString, required = true,
                                 default = nil)
  if valid_581236 != nil:
    section.add "parent", valid_581236
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
  var valid_581237 = query.getOrDefault("upload_protocol")
  valid_581237 = validateParameter(valid_581237, JString, required = false,
                                 default = nil)
  if valid_581237 != nil:
    section.add "upload_protocol", valid_581237
  var valid_581238 = query.getOrDefault("fields")
  valid_581238 = validateParameter(valid_581238, JString, required = false,
                                 default = nil)
  if valid_581238 != nil:
    section.add "fields", valid_581238
  var valid_581239 = query.getOrDefault("quotaUser")
  valid_581239 = validateParameter(valid_581239, JString, required = false,
                                 default = nil)
  if valid_581239 != nil:
    section.add "quotaUser", valid_581239
  var valid_581240 = query.getOrDefault("alt")
  valid_581240 = validateParameter(valid_581240, JString, required = false,
                                 default = newJString("json"))
  if valid_581240 != nil:
    section.add "alt", valid_581240
  var valid_581241 = query.getOrDefault("oauth_token")
  valid_581241 = validateParameter(valid_581241, JString, required = false,
                                 default = nil)
  if valid_581241 != nil:
    section.add "oauth_token", valid_581241
  var valid_581242 = query.getOrDefault("callback")
  valid_581242 = validateParameter(valid_581242, JString, required = false,
                                 default = nil)
  if valid_581242 != nil:
    section.add "callback", valid_581242
  var valid_581243 = query.getOrDefault("access_token")
  valid_581243 = validateParameter(valid_581243, JString, required = false,
                                 default = nil)
  if valid_581243 != nil:
    section.add "access_token", valid_581243
  var valid_581244 = query.getOrDefault("uploadType")
  valid_581244 = validateParameter(valid_581244, JString, required = false,
                                 default = nil)
  if valid_581244 != nil:
    section.add "uploadType", valid_581244
  var valid_581245 = query.getOrDefault("zone")
  valid_581245 = validateParameter(valid_581245, JString, required = false,
                                 default = nil)
  if valid_581245 != nil:
    section.add "zone", valid_581245
  var valid_581246 = query.getOrDefault("key")
  valid_581246 = validateParameter(valid_581246, JString, required = false,
                                 default = nil)
  if valid_581246 != nil:
    section.add "key", valid_581246
  var valid_581247 = query.getOrDefault("$.xgafv")
  valid_581247 = validateParameter(valid_581247, JString, required = false,
                                 default = newJString("1"))
  if valid_581247 != nil:
    section.add "$.xgafv", valid_581247
  var valid_581248 = query.getOrDefault("projectId")
  valid_581248 = validateParameter(valid_581248, JString, required = false,
                                 default = nil)
  if valid_581248 != nil:
    section.add "projectId", valid_581248
  var valid_581249 = query.getOrDefault("prettyPrint")
  valid_581249 = validateParameter(valid_581249, JBool, required = false,
                                 default = newJBool(true))
  if valid_581249 != nil:
    section.add "prettyPrint", valid_581249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581250: Call_ContainerProjectsLocationsOperationsList_581233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations in a project in a specific zone or all zones.
  ## 
  let valid = call_581250.validator(path, query, header, formData, body)
  let scheme = call_581250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581250.url(scheme.get, call_581250.host, call_581250.base,
                         call_581250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581250, url, valid)

proc call*(call_581251: Call_ContainerProjectsLocationsOperationsList_581233;
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
  var path_581252 = newJObject()
  var query_581253 = newJObject()
  add(query_581253, "upload_protocol", newJString(uploadProtocol))
  add(query_581253, "fields", newJString(fields))
  add(query_581253, "quotaUser", newJString(quotaUser))
  add(query_581253, "alt", newJString(alt))
  add(query_581253, "oauth_token", newJString(oauthToken))
  add(query_581253, "callback", newJString(callback))
  add(query_581253, "access_token", newJString(accessToken))
  add(query_581253, "uploadType", newJString(uploadType))
  add(path_581252, "parent", newJString(parent))
  add(query_581253, "zone", newJString(zone))
  add(query_581253, "key", newJString(key))
  add(query_581253, "$.xgafv", newJString(Xgafv))
  add(query_581253, "projectId", newJString(projectId))
  add(query_581253, "prettyPrint", newJBool(prettyPrint))
  result = call_581251.call(path_581252, query_581253, nil, nil, nil)

var containerProjectsLocationsOperationsList* = Call_ContainerProjectsLocationsOperationsList_581233(
    name: "containerProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "container.googleapis.com", route: "/v1/{parent}/operations",
    validator: validate_ContainerProjectsLocationsOperationsList_581234,
    base: "/", url: url_ContainerProjectsLocationsOperationsList_581235,
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
